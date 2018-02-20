cd /vagrant

mix release --env=prod --verbose

HOST=localhost \
MNESIA_HOST=bs@127.0.0.1 \
MNESIA_STORAGE_TYPE=ram_copies \
PORT=3000 \
SECRET_KEY_BASE=tbFePEIYrMaNfKmTHZZT9IrdebmVbS3FnCTOp/AAWklO9Jxnhua1YlGaMLzYz2yy

_build/prod/rel/bs/bin/bs foreground
