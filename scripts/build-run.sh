cd /vagrant

export HOST=localhost
export MNESIA_HOST=bs@127.0.0.1
export MNESIA_STORAGE_TYPE=ram_copies
export PORT=3000
export SECRET_KEY_BASE=tbFePEIYrMaNfKmTHZZT9IrdebmVbS3FnCTOp/AAWklO9Jxnhua1YlGaMLzYz2yy
export PATH="$PATH:/vagrant/node_modules/.bin"

mix phx.server
