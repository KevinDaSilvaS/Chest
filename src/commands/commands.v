module commands

import helpers as h
import storage as stg
import log

pub fn help() {
	println('Welcome to Chest')
	println('$h.blue() [init] $h.reset() Sets a new installation or updates the storage \n gist by passing the github token')
	println('	usage example: $h.blue() [ chest init MY_GITHUB_TOKEN_STRING MY_UNIQUE_PASSWORD ] $h.reset()')

	println('$h.blue() [put] $h.reset() Creates or updates a password')
	println('	usage example: $h.blue() [ chest put my_facebook_password=pASSword12345 ] $h.reset()')

	println('$h.blue() [get] $h.reset() Lists all passwords')
	println('	usage example: $h.blue() [ chest get MY_UNIQUE_PASSWORD ] $h.reset()')
}

pub fn init(token string, password string) {
	log.info('Trying to create gist in github...')
	res := stg.create_gist(token, password)
	if res.failed {
		log.error('Unable to create gist, setup failed')
		return
	}

	log.info('Trying to create config file...')
	if !stg.create_config_file(res.gist_url, token, password) {
		log.error('Unable to create config file, setup failed')
		return
	}

	log.debug('Chest configured with success')
}

pub fn put(key string, password string) {
	if !stg.add_password_to_config(key, password) {
		log.error('Unable to create password')
		return
	}

	if !stg.add_password_to_gist(key, password) {
		log.error('Unable to create password in gist, gonna try again later')
	}

	log.debug('New password added with success')
	return
}

pub fn get(password string) {
	res := stg.list_passwords(password)
	if res.failed {
		log.error('Unable to get passwords')
		return
	}

	for pass in res.passwords {
		println(pass)
	}
	return
}