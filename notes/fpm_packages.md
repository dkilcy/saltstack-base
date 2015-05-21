
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
mkdir /tmp/nodejs
make install DESTDIR=/tmp/nodejs/
fpm -s dir -t rpm -n nodejs -v 0.12.3 -C /tmp/nodejs/ usr/bin usr/lib
```

#### Create Tengine with LuaJIT support
```
cd /usr/local/src


wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
tar zxvf tengine-2.1.0.tar.gz
cd tengine-2.1.0
/configure --with-http_lua_module \
            --prefix=/opt/nginx \
            --error-log-path=/var/log/nginx/nginx_error.log \
            --conf-path=/etc/nginx/nginx.conf \
            --with-luajit-inc=/opt/LuaJIT-2.0.3/include/luajit-2.0 \
            --with-luajit-lib=/opt/LuaJIT-2.0.3/lib       
            
make
mkdir /tmp/tengine
make install DESTDIR=/tmp/nodejs/
fpm -s dir -t rpm -n tengine 
```


#### References
- [How do you install Node.JS on CentOS?](http://serverfault.com/questions/299288/how-do-you-install-node-js-on-centos)
