module helpers

pub struct Config {
	pub:
		gist_url string
		token string
		password string
	pub mut:
		storage map[string]string
}

pub struct GistHistory {
	user map[string]string
	version string
	committed_at string
	change_status map[string]int
	url string
}

pub struct GistCreationResponse {
	pub: 
  		url string
  		forks_url string
  		commits_url string
  		id string
  		node_id string
  		git_pull_url string
  		git_push_url string
  		html_url string
  		files map[string]map[string]string
  		public bool
		created_at string
		updated_at string
		description string
		comments u64
  		user string = 'oi'
  		comments_url string
  		owner map[string]string
  		forks []string
  		history []GistHistory
  		truncated bool
}

pub struct ReturnGistResponse {
	pub:
		gist_url string
		failed bool
}