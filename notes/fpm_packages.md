
### Using fpm to create packages

#### Setup FPM
```
yum groupinstall "Development Tools"
yum install gcc-c++ openssl-devel
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
rm -Rf /tmp/node-v0.12.3
mkdir /tmp/node-v0.12.3
make install DESTDIR=/tmp/node-v0.12.3/
fpm -s dir -t rpm -n nodejs -v 0.12.3 -C /tmp/node-v0.12.3/ usr/bin usr/lib
#rpm -q -filesbypkg -p 
```

#### Create Tengine with LuaJIT support
```
yum install pcre-devel

cd /usr/local/src
wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
cd LuaJIT-2.0.4
make clean
make amalg PREFIX=/usr
rm -Rf /tmp/LuaJIT-2.0.4
make install PREFIX=/usr DESTDIR=/tmp/LuaJIT-2.0.4

cd /usr/local/src
wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
tar zxvf tengine-2.1.0.tar.gz
cd tengine-2.1.0
./configure --with-http_lua_module \
  --prefix=/usr/share/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --with-luajit-inc=/tmp/LuaJIT-2.0.4/usr/include/luajit-2.0 \
  --with-luajit-lib=/tmp/LuaJIT-2.0.4/usr/lib \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx/nginx.pid \
  --lock-path=/var/run/nginx/nginx.lock
make
rm -Rf /tmp/tengine-2.1.0
mkdir /tmp/tengine-2.1.0
make install DESTDIR=/tmp/tengine-2.1.0/
rm -f tengine-2.1.0-1.x86_64.rpm
fpm -s dir -t rpm -n tengine -v 2.1.0 -C /tmp/tengine-2.1.0/ usr/share/nginx etc/nginx
rpm -q -filesbypkg -p tengine-2.1.0-1.x86_64.rpm
```


#### References
- [Effing Package Management](https://github.com/jordansissel/fpm)
- [How do you install Node.JS on CentOS?](http://serverfault.com/questions/299288/how-do-you-install-node-js-on-centos)
