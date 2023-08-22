# 2023_inhatc
2023 년 3학년 2학기 (A,C반)

## 초기 설정
```
$ sudo apt update
$ sudo apt upgrade
```

  - 한글깨짐
```
$ sudo apt-get install fonts-unfonts-core
$ sudo apt-get install ibus ibus-hangul
$ sudo reboot
```

## InfluxDB 설치 
  - InfluxDB download key using curl
```
$ curl https://repos.influxdata.com/influxdata-archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/influxdb-archive-keyring.gpg >/dev/null
```
  - Add repository to the sources list
```
echo "deb [signed-by=/usr/share/keyrings/influxdb-archive-keyring.gpg] https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
```
  - Packages are up to date
```
$ sudo apt update
```
  - Install InfluxDB
```
$ sudo apt install influxdb
```
  - InfluxDB start at boot
```
$ sudo systemctl unmask influxdb
$ sudo systemctl enable influxdb
```
  - proceed to start up InfluxDB on RaspberryPi
```
$ sudo systemctl enable influxdb
```


