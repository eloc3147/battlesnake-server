export MIX_ENV=prod
export VERBOSE=1

curl -s -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node

cd /vagrant

mix do local.hex --force, local.rebar, deps.get, deps.compile, compile
yarn install
