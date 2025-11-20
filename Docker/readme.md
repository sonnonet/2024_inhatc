# 도커 설치
```
# Docker의 패키지를 안전하게 설치하려면 Docker의 공식 GPG 키를 받아야 합니다. 이 키는 Docker 패키지가 신뢰할 수 있는 출처에서 온 것임을 보장

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 이 단계에서는 Docker의 공식 저장소를 APT 소스 목록에 추가합니다. 이를 통해 시스템은 Docker 패키지를 apt-get으로 설치할 수 있게 됨
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

```

## 최신 버전 설치
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## 테스트
```
sudo docker run hello-world
```
