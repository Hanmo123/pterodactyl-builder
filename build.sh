mkdir panel nginx
cd panel

wget https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzf panel.tar.gz
rm panel.tar.gz

cp ../Dockerfile.Panel Dockerfile
docker build -t pterodactyl-panel:latest .

cd ..

cd nginx
cp ../Dockerfile.Nginx Dockerfile
cp ../nginx-site.conf nginx-site.conf
docker build -t pterodactyl-nginx:latest .

rm -rf panel nginx
