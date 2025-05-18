#!/bin/bash

echo "💾 [12] 스왑 상태 확인 중..."
sudo free -m
sudo swapon -s

echo "📂 [13] 스왑 파일 생성 중 (2GB)..."
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo "📝 [14] fstab에 스왑 자동 등록..."
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab > /dev/null

echo "✅ [15] 스왑 활성화 확인..."
sudo swapon --show

echo "🔁 [16] systemd 재적용 중..."
sudo systemctl daemon-reexec