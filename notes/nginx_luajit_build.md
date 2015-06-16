
### Build NGINX with LuaJIT support on CentOS 6.6

```
yum -y groupinstall "Development Tools"
cd /usr/local/src
```

```
wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
for i in `ls`; do tar zxvf $i; done
```

```
cd LuaJIT-2.0.4
make PREFIX=/usr
rm -Rf /tmp/LuaJIT-2.0.4
make
make install PREFIX=/usr DESTDIR=/tmp/LuaJIT-2.0.4
make install PREFIX=/usr
```

```
yum install pcre-devel openssl-devel

cd tengine-2.1.0
./configure --with-http_lua_module \
  --prefix=/usr \
  --conf-path=/etc/nginx/nginx.conf \
  --with-luajit-inc=/usr/include/luajit-2.0 \
  --with-luajit-lib=/usr/lib \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock
make
make install PREFIX=/usr DESTDIR=/tmp/tengine-2.1.0
make install PREFIX=/usr
```

```
[root@conn1 sbin]$ which nginx
/usr/sbin/nginx
```

```
[root@conn1 sbin]$ nginx -V
Tengine version: Tengine/2.1.0 (nginx/1.6.2)
built by gcc 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) 
TLS SNI support enabled
configure arguments: --with-http_lua_module --prefix=/usr --conf-path=/etc/nginx/nginx.conf --with-luajit-inc=/usr/include/luajit-2.0 --with-luajit-lib=/usr/lib --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock
loaded modules:
    ngx_core_module (static)
    ngx_errlog_module (static)
    ngx_conf_module (static)
    ngx_dso_module (static)
    ngx_syslog_module (static)
    ngx_events_module (static)
    ngx_event_core_module (static)
    ngx_epoll_module (static)
    ngx_procs_module (static)
    ngx_proc_core_module (static)
    ngx_openssl_module (static)
    ngx_regex_module (static)
    ngx_http_module (static)
    ngx_http_core_module (static)
    ngx_http_log_module (static)
    ngx_http_upstream_module (static)
    ngx_http_static_module (static)
    ngx_http_autoindex_module (static)
    ngx_http_index_module (static)
    ngx_http_auth_basic_module (static)
    ngx_http_access_module (static)
    ngx_http_limit_conn_module (static)
    ngx_http_limit_req_module (static)
    ngx_http_geo_module (static)
    ngx_http_map_module (static)
    ngx_http_split_clients_module (static)
    ngx_http_referer_module (static)
    ngx_http_rewrite_module (static)
    ngx_http_ssl_module (static)
    ngx_http_proxy_module (static)
    ngx_http_fastcgi_module (static)
    ngx_http_uwsgi_module (static)
    ngx_http_scgi_module (static)
    ngx_http_memcached_module (static)
    ngx_http_empty_gif_module (static)
    ngx_http_browser_module (static)
    ngx_http_user_agent_module (static)
    ngx_http_upstream_ip_hash_module (static)
    ngx_http_upstream_consistent_hash_module (static)
    ngx_http_upstream_check_module (static)
    ngx_http_upstream_least_conn_module (static)
    ngx_http_reqstat_module (static)
    ngx_http_upstream_keepalive_module (static)
    ngx_http_upstream_dynamic_module (static)
    ngx_http_stub_status_module (static)
    ngx_http_write_filter_module (static)
    ngx_http_header_filter_module (static)
    ngx_http_chunked_filter_module (static)
    ngx_http_range_header_filter_module (static)
    ngx_http_gzip_filter_module (static)
    ngx_http_postpone_filter_module (static)
    ngx_http_ssi_filter_module (static)
    ngx_http_charset_filter_module (static)
    ngx_http_userid_filter_module (static)
    ngx_http_footer_filter_module (static)
    ngx_http_trim_filter_module (static)
    ngx_http_headers_filter_module (static)
    ngx_http_lua_module (static)
    ngx_http_upstream_session_sticky_module (static)
    ngx_http_copy_filter_module (static)
    ngx_http_range_body_filter_module (static)
    ngx_http_not_modified_filter_module (static)
```
```
[root@conn1 nginx]$ nginx
[root@conn1 nginx]$ ps -ef | grep nginx
root     11012     1  0 01:53 ?        00:00:00 nginx: master process nginx
nobody   11013 11012  0 01:53 ?        00:00:00 nginx: worker process
root     11015  1806  0 01:53 pts/0    00:00:00 grep nginx
[root@conn1 nginx]$ curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to tengine!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to tengine!</h1>
<p>If you see this page, the tengine web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://tengine.taobao.org/">tengine.taobao.org</a>.</p>

<p><em>Thank you for using tengine.</em></p>
</body>
</html>
```

https://rubygems.org/gems/

```
rm: remove regular file `clamp-1.0.0.gem'? y
[root@conn1 fpm-1.3.3]$ gem install fpm
ERROR:  http://rubygems.org/ does not appear to be a repository
Successfully installed clamp-0.6.5
Successfully installed fpm-1.3.3
2 gems installed
Installing ri documentation for clamp-0.6.5...
Installing ri documentation for fpm-1.3.3...
Installing RDoc documentation for clamp-0.6.5...
Installing RDoc documentation for fpm-1.3.3...
```

```
[root@conn1 fpm-1.3.3]$ fpm
Missing required -s flag. What package source did you want? {:level=>:warn}
Missing required -t flag. What package output did you want? {:level=>:warn}
No parameters given. You need to pass additional command arguments so that I know what you want to build packages from. For example, for '-s dir' you would pass a list of files and directories. For '-s gem' you would pass a one or more gems to package from. As a full example, this will make an rpm of the 'json' rubygem: `fpm -s gem -t rpm json` {:level=>:warn}
Fix the above problems, and you'll be rolling packages in no time! {:level=>:fatal}
[root@conn1 fpm-1.3.3]$ ls -l
total 1484
-rw-r--r-- 1 root root  15360 Jun 16 02:07 arr-pm-0.0.10.gem
-rw-r--r-- 1 root root  89600 Jun 16 02:07 backports-3.6.4.gem
-rw-r--r-- 1 root root  20992 Jun 16 02:07 cabin-0.7.1.gem
-rw-r--r-- 1 root root  28672 Jun 16 02:07 childprocess-0.5.6.gem
-rw-r--r-- 1 root root  24576 Jun 16 02:07 clamp-0.6.5.gem
-rw-r--r-- 1 root root 881152 Jun 16 02:07 ffi-1.9.8.gem
-rw-r--r-- 1 root root 114176 Jun 16 02:07 fpm-1.3.3.gem
-rw-r--r-- 1 root root   9728 Jun 16 02:07 insist-1.0.0.gem
-rw-r--r-- 1 root root 152064 Jun 16 02:07 json-1.8.3.gem
-rw-r--r-- 1 root root 135680 Jun 16 02:07 pry-0.10.1.gem
-rw-r--r-- 1 root root  10240 Jun 16 02:07 rspec-3.3.0.gem
-rw-r--r-- 1 root root  14336 Jun 16 02:07 stud-0.0.19.gem
[root@conn1 fpm-1.3.3]$ 
```

```
cd /usr/local/src/tengine-2.1.0
fpm -s dir -t rpm -n tengine -v 2.1.0 -C /tmp/tengine-2.1.0 usr etc
rpm -q -filesbypkg -p tengine-2.1.0-1.x86_64.rpm
```

```
fpm -s dir -t rpm -n LuaJIT -v 2.0.4 -C /tmp/LuaJIT-2.0.4 usr
rpm -q -filesbypkg -p LuaJIT-2.0.4-1.x86_64.rpm
```


