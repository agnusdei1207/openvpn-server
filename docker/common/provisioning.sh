#!/bin/bash

echo "🚀 Docker 설치 스크립트 시작"

# 이미 설치되었는지 확인
if command -v docker &> /dev/null; then
    echo "✅ Docker가 이미 설치되어 있습니다."
    docker --version
    exit 0
fi

echo "🧱 1단계: Docker 설치 준비"
# 시스템 패키지 업데이트
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "🔹 Docker GPG 키 등록"
# GPG 키 디렉토리가 없으면 생성
sudo mkdir -p /etc/apt/keyrings
# 기존 키가 있으면 삭제
sudo rm -f /etc/apt/keyrings/docker.gpg
# Docker의 공식 GPG 키 다운로드 및 저장
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "🔹 Docker 저장소 등록"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔹 Docker 설치 중..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 현재 사용자를 docker 그룹에 추가 (재로그인 없이 docker 명령어 사용 가능)
echo "🔹 사용자 권한 설정 중..."
sudo usermod -aG docker $USER

# Docker 서비스 상태 확인
echo "🔹 Docker 서비스 상태 확인"
sudo systemctl status docker --no-pager || true

echo "✅ Docker 설치 완료! 시스템에 적용하려면 로그아웃 후 다시 로그인하세요."
echo "🐳 Docker 버전 정보:"
docker --version || true

# 현재 사용자에게 권한이 적용되었는지 확인
if ! docker ps &>/dev/null; then
    echo "⚠️ 현재 세션에서는 권한이 적용되지 않았습니다. 로그아웃 후 다시 로그인하세요."
    echo "  또는 다음 명령어로 현재 세션에서 그룹 멤버십을 적용할 수 있습니다:"
    echo "  $ newgrp docker"
fi