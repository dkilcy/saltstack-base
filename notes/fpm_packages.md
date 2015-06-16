
### Using FPM to create packages

#### Setup FPM
```
yum groupinstall "Development Tools"
yum install ruby-devel rubygems
gem install fpm
```

#### Create NodeJS package
```
cd /usr/local/src

wget http://nodejs.org/dist/node-v0.12.3.tar.gz
tar zxvf node-latest.tar.gz
cd node-v0.12.3
./configure --prefix=/usr/
make 
make install DESTDIR=/tmp/node-v0.12.3/
fpm -s dir -t rpm -n nodejs -v 0.12.3 -C /tmp/node-v0.12.3/ usr
rpm -q -filesbypkg -p 
```


#### References
- [Effing Package Management](https://github.com/jordansissel/fpm)
- [How do you install Node.JS on CentOS?](http://serverfault.com/questions/299288/how-do-you-install-node-js-on-centos)
