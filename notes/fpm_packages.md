
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
```

#### Create Tengine with LuaJIT support
```
cd /usr/local/src
wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
cd LuaJIT-2.0.4
make
rm -Rf /tmp/LuaJIT-2.0.4
make install DESTDIR=/tmp/LuaJIT-2.0.4

yum install pcre-devel
cd /usr/local/src
wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
tar zxvf tengine-2.1.0.tar.gz
cd tengine-2.1.0
./configure --with-http_lua_module \
            --conf-path=/etc/nginx/nginx.conf \
            --with-luajit-inc=/tmp/LuaJIT-2.0.4/usr/local/include/luajit-2.0 \
            --with-luajit-lib=/tmp/LuaJIT-2.0.4/usr/local/lib       
            
make
rm -Rf /tmp/tengine-2.1.0
mkdir /tmp/tengine-2.1.0
make install DESTDIR=/tmp/tengine-2.1.0/
fpm -s dir -t rpm -n tengine -v 2.1.0 -C /tmp/tengine-2.1.0/ usr/local/nginx etc/nginx
```


#### References
- [How do you install Node.JS on CentOS?](http://serverfault.com/questions/299288/how-do-you-install-node-js-on-centos)
