# rasbperrypi 5 
## install openCV Full
## Swap 


```
  # enlarge the boundary (CONF_MAXSWAP)
$ sudo vim /sbin/dphys-swapfile   CONF_MAXSWAP = 2048  -> CONF_MAXSWAP = 4096
  # give the required memory size (CONF_SWAPSIZE)
$ sudo nano /etc/dphys-swapfile   CONF_SWAPSIZE = 200 -> CONF_SWAPSIZE = 4096
$ sudo reboot
```
