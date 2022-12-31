# install libnss3-tools
sudo apt install libnss3-tools

# install go
sudo apt-get install golang-go

# download mkcert
git clone https://github.com/FiloSottile/mkcert
cd mkcert

# build mkcert
go build -ldflags "-X main.Version=$(git describe --tags)"

# link mkcert to /usr/bin
sudo ln -s $PWD/mkcert /usr/bin/mkcert

# install mkcert root certificate
mkcert -install

# install localhost certificate
mkcert -key-file ~/localhost-key.pem -cert-file ~/localhost-cert.pem localhost

# install stunnel
sudo apt-get install stunnel

# create bundled certificate for stunnel
cat ~/localhost-key.pem ~/localhost-cert.pem > ~/localhost-bundle.pem

# set permissions for certificates
chmod 600 ~/localhost-bundle.pem ~/localhost-key.pem ~/localhost-cert.pem

# start PHP built in server
php -S localhost:8080

# start stunnel
sudo stunnel3 -f -d 443 -r 8080 -p ~/localhost-bundle.pem
