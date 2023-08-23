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
  - InfluxDB download key using wget
```
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
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


