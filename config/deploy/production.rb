server "142.93.238.117", user: "deployer", roles: %w{app db web}, primary: true

role :app, %w{deployer@142.93.238.117}
role :web, %w{deployer@142.93.238.117}
role :db,  %w{deployer@142.93.238.117}

set :rails_env, :production
set :stage, :production

set :ssh_options, {
  keys: "/Users/yuneszadi/.ssh/id_rsa",
  forward_agent: true,
  auth_methods: %w(publickey password),
}
