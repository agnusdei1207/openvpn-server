#!/bin/bash

# 기본값 2GB, 매개변수로 전달 가능 (단위: GB)
SWAP_GB_SIZE=${1:-2}

echo "💾 [1] 스왑 상태 확인 중..."
sudo free -m
sudo swapon -s

echo "📂 [2] 스왑 파일 생성 중 (${SWAP_GB_SIZE}GB)..."
sudo fallocate -l ${SWAP_GB_SIZE}G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo "📝 [3] fstab에 스왑 자동 등록..."
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab > /dev/null

echo "✅ [4] 스왑 활성화 확인..."
sudo swapon --show

echo "🔁 [5] systemd 재적용 중..."
sudo systemctl daemon-reexec