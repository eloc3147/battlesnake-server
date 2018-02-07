OTP_VERSION=20.2.2
OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz"
OTP_DOWNLOAD_SHA256="7614a06964fc5022ea4922603ca4bf1d2cc241f9bd6b7321314f510fd74c7304"
curl -fSLs -o otp-src.tar.gz "$OTP_DOWNLOAD_URL"
echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c

sudo apt-get update
sudo apt-get install -qq dpkg-dev dpkg gcc g++ libc-dev make autoconf ncurses-dev unixodbc-dev tar \
                         lksctp-tools pax-utils unzip git libgmp3-dev npm openssl
export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}"
mkdir -vp $ERL_TOP
tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1
rm otp-src.tar.gz
(
    cd $ERL_TOP
    ./otp_build autoconf
    gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
    ./configure --build="$gnuArch"
    make -s -j$(getconf _NPROCESSORS_ONLN)
    make install
)
rm -rf $ERL_TOP
find /usr/local -regex '/usr/local/lib/erlang/\(lib/\|erts-\).*/\(man\|doc\|obj\|c_src\|emacs\|info\|examples\)' | xargs rm -rf
find /usr/local -name src | xargs -r find | grep -v '\.hrl$' | xargs rm -v || true
find /usr/local -name src | xargs -r find | xargs rmdir -vp || true
scanelf --nobanner -E ET_EXEC -BF '%F' --recursive /usr/local | xargs -r strip --strip-all
scanelf --nobanner -E ET_DYN -BF '%F' --recursive /usr/local | xargs -r strip --strip-unneeded

ELIXIR_VERSION="v1.6.0"
LANG=C.UTF-8

ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip"
ELIXIR_DOWNLOAD_SHA256="f848bc7f88f9c252b3610a9995679889ce18073d0f0a061533c12e622b2ac9e7"

curl -fSLs -o elixir-precompiled.zip $ELIXIR_DOWNLOAD_URL
echo "$ELIXIR_DOWNLOAD_SHA256  elixir-precompiled.zip" | sha256sum -c -
unzip -qq -d /usr/local elixir-precompiled.zip
rm elixir-precompiled.zip

MIX_ENV=prod
VERBOSE=1

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node

cd /vagrant
sudo npm install -g yarn


mix do local.hex --force, local.rebar, deps.get, deps.compile, compile
yarn install && yarn webpack:production && mix phx.digest
