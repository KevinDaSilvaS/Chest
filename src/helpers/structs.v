module helpers

pub struct Config {
	pub:
		gist_url string
		token string
		password string
	pub mut:
		storage map[string]string
}