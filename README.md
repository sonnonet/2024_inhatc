# 2023_inhatc
2023 년 3학년 2학기 (A,C반)

## 라즈베리파이 초기 설정
```
sudo apt update
sudo apt upgrade
```

  - 한글깨짐
```
sudo apt-get install fonts-unfonts-core -y
sudo apt-get install ibus ibus-hangul -y
sudo reboot
```

## InfluxDB2 설치 
  - InfluxDB download key using wget
```
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
```
  - Packages are up to date && install Influxdb2
```
sudo apt-get update && sudo apt-get install influxdb2 -y
```
  - InfluxDB as a background service on startup
```
sudo service influxdb start
```
  - InfluxDB is status (service)
```
sudo service influxdb status
```

### InfluxDB2 web setting
  - localhost:8086 접속
  - GET STARTED

 <img width="400" height="500" src="./capture/influxdb_1.png"></img>

  - Setup Initial User
  - (pi , raspberry)
  - Organization Name (study)
  - Bucket Name (DatabaseName)
    - test

   <img width="500" height="600" src="./capture/influxdb_2.png"></img>



