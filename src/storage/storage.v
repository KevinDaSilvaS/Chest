module storage

import json
import crypto.sha256 as cr
import encoding.base64 as b64
import os
import helpers as h

__global (path = './src/storage/config.json')

pub fn create_config_file(token string, password string) bool {
	mut m := map[string]string{}
	config := h.Config{'gist', b64.encode_str(token), cr.hexhash(password), m}
	json_config := json.encode(config)
	os.write_file(path, json_config) or {
		return false
	}

	return true
}