module storage

import json
import crypto.sha256 as cr
import encoding.base64 as b64
import os
import net.http
import helpers as h

__global (path = './src/storage/config.json')
__global (github_url = 'https://api.github.com/gists')

pub fn create_config_file(gist_url string, token string, password string) bool {
	mut m := map[string]string{}
	config := h.Config{gist_url, b64.encode_str(token), cr.hexhash(password), m}
	json_config := json.encode(config)
	os.write_file(path, json_config) or {
		return false
	}

	return true
}

pub fn create_gist(token string, password string) h.ReturnGistResponse {
	hashed := cr.hexhash(password)
	data := '{"description":"Chest gist secrets","public":false,"files":{"chest.secrets":{"content":"CHEST_PASSWORD=$hashed|"}}}'
	mut req := http.new_request(http.Method.post, github_url, data)

	req.add_custom_header('Authorization', 'Bearer $token') or {}
	req.add_custom_header('X-GitHub-Api-Version', '2022-11-28') or {}

	res := req.do() or {
		return h.ReturnGistResponse{ '', true } 
	}

	decoded_response := json.decode(h.GistCreationResponse, res.body) or {
		return h.ReturnGistResponse{ '', true } 
	}

	return h.ReturnGistResponse{ decoded_response.url, false } 
}

pub fn list_passwords(password string) h.ReturnListPasswords {
	data := os.read_file(path) or {
		return h.ReturnListPasswords{[], true}
	}

	config := json.decode(h.Config, data) or {
		return h.ReturnListPasswords{ [], true } 
	}

	if config.password != cr.hexhash(password) {
		return h.ReturnListPasswords{ [], true }
	}

	tags := config.storage.keys()
	passwords := config.storage.values()

	mut formatted_passwords := []string{len: tags.len}
	for i, tag in tags {
		password_stored := b64.decode_str(passwords[i])
		formatted_passwords << '$tag: $password_stored'
	}

	return h.ReturnListPasswords{formatted_passwords, false}
}