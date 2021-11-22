apt-get update -y &&
apt-get upgrade -y
apt install -y docker.io &&
docker pull anvie/nuchain:latest &&
mkdir -p /var/data/chains/nuc01 &&
wget -P /var/data/ https://motivasee.com/nuchain.7z &&
apt install p7zip-full &&
7za x -y /var/data/nuchain.7z -o/var/data/chains/nuc01 &&
# mv /var/data/db /var/data/chains/nuc01/ &&
# rm -r /var/data/nuchain.7z &&
cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime &&
apt install ncdu &&
apt install htop &&
apt autoremove &&
apt-get autoclean &&
echo "
[Unit]
Description=Nuchain Node Container
After=docker.service
Requires=docker.service

[Service]
Type=simple
Restart=always
RestartSec=5
StartLimitBurst=5
LimitNOFILE=10000
ExecStartPre=-/usr/bin/docker stop nuchain
ExecStartPre=-/usr/bin/docker rm nuchain
ExecStart=/usr/bin/docker run --rm -v '/var/data:/data' -p '9933:9933' -p '9944:9944' -p '30333:30333' --name nuchain anvie/nuchain:latest nuchain --validator --base-path=/data --ws-external --rpc-external --rpc-methods=Unsafe --unsafe-pruning --pruning=6000 --name='CATELYN STARK'

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/nuchain.service &&
systemctl daemon-reload &&
systemctl enable nuchain &&
systemctl start nuchain &&
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9933
