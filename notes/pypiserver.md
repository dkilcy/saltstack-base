
## pypiserver Setup

Implementation of pypiserver on CentOS 7

Tested versions.

- CentOS Linux release 7.3.1611 (Core) 


```
yum install python-pip libffi-devel gcc python-devel openssl-devel
pip install --upgrade setuptools
```

```
pip install --no-index --find-links /var/www/html/pypiserver/packages setuptools-36.0.1.zip
```

```
yum install python-virtualenv
mkdir -p ~/env ; cd ~/env
virtualenv pypiserver
source pypiserver/bin/activate
```

```
pip install --no-index --find-links /var/www/html/pypiserver/packages pypiserver-1.2.0.zip
```

```
pypi-server -p 8080 /var/www/html/pypiserver/packages
```

```
deactivate
```

### Reference Implementation

Packages to be hosted by the pypiserver:

```
[root@ws2 ~]$ ls -l /var/www/html/pypiserver/packages/
total 22844
-rw-rw-r-- 1 devops devops 2511062 Jun 11 13:01 ansible-2.2.1.0.tar.gz
-rw-rw-r-- 1 devops devops 2512540 Jun 11 11:40 ansible-2.2.3.0.tar.gz
-rw-rw-r-- 1 devops devops    5605 Jun 11 13:17 backports.ssl_match_hostname-3.5.0.1.tar.gz
-rw-rw-r-- 1 devops devops 8317217 Jun 11 14:31 boto-2.45.0.tar.gz
-rw-rw-r-- 1 devops devops 1460723 Jun 11 14:31 boto-2.47.0.tar.gz
-rw-rw-r-- 1 devops devops   84129 Jun 11 13:11 docker-py-1.10.6.tar.gz
-rw-rw-r-- 1 devops devops   71968 Jun 11 11:35 docker-py-1.8.1.tar.gz
-rw-rw-r-- 1 devops devops    7555 Jun 11 13:16 docker-pycreds-0.2.1.tar.gz
-rw-rw-r-- 1 devops devops   55579 Jun 11 13:07 ecdsa-0.13.tar.gz
-rw-rw-r-- 1 devops devops   32475 Jun 11 13:16 ipaddress-1.0.18.tar.gz
-rw-rw-r-- 1 devops devops  378300 Jun 11 13:39 Jinja2-2.7.2.tar.gz
-rw-rw-r-- 1 devops devops   14356 Jun 11 13:32 MarkupSafe-1.0.tar.gz
-rw-rw-r-- 1 devops devops 1362604 Jun 11 13:04 paramiko-1.16.1.tar.gz
-rw-rw-r-- 1 devops devops 1139175 Jun 11 18:12 pip-8.1.1.tar.gz
-rw-rw-r-- 1 devops devops 1197370 Jun 11 18:01 pip-9.0.1.tar.gz
-rw-rw-r-- 1 devops devops  446240 Jun 11 13:42 pycrypto-2.6.1.tar.gz
-rw-rw-r-- 1 devops devops  110437 Jun 11 18:18 pypiserver-1.2.0.zip
-rw-rw-r-- 1 devops devops  253011 Jun 11 13:41 PyYAML-3.12.tar.gz
-rw-rw-r-- 1 devops devops  545246 Jun 11 11:39 requests-2.12.1.tar.gz
-rw-rw-r-- 1 devops devops  711296 Jun 11 13:13 setuptools-36.0.1.zip
-rw-rw-r-- 1 devops devops   29630 Jun 11 14:16 six-1.10.0.tar.gz
-rw-rw-r-- 1 devops devops 1863951 Jun 11 14:37 virtualenv-15.1.0.tar.gz
-rw-rw-r-- 1 devops devops  196203 Jun 11 13:14 websocket_client-0.40.0.tar.gz
-rw-rw-r-- 1 devops devops   37351 Jun 11 14:36 wsgiref-0.1.2.zip
[root@ws2 ~]$ 
```

#### Example Setup

```
[root@ws2 ~]$ yum install python-pip libffi-devel gcc python-devel openssl-devel
Loaded plugins: fastestmirror, langpacks, priorities
Loading mirror speeds from cached hostfile
 * epel: mirror.cs.princeton.edu
Package python2-pip-8.1.2-5.el7.noarch already installed and latest version
Package libffi-devel-3.0.13-18.el7.x86_64 already installed and latest version
Package gcc-4.8.5-11.el7.x86_64 already installed and latest version
Package python-devel-2.7.5-48.el7.x86_64 already installed and latest version
Package 1:openssl-devel-1.0.1e-60.el7_3.1.x86_64 already installed and latest version
Nothing to do
[root@ws2 ~]$ pip install --upgrade setuptools
Requirement already up-to-date: setuptools in /usr/lib/python2.7/site-packages
You are using pip version 8.1.1, however version 9.0.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
[root@ws2 ~]$ yum install python-virtualenv
Loaded plugins: fastestmirror, langpacks, priorities
Loading mirror speeds from cached hostfile
 * epel: mirror.cs.princeton.edu
Package python-virtualenv-1.10.1-3.el7.noarch already installed and latest version
Nothing to do
[root@ws2 ~]$ mkdir -p ~/env ; cd ~/env
[root@ws2 env]$ virtualenv pypiserver
New python executable in pypiserver/bin/python
Installing setuptools, pip, wheel...done.
[root@ws2 env]$ source pypiserver/bin/activate
(pypiserver)[root@ws2 env]$ 
(pypiserver)[root@ws2 env]$ pip install --no-index --find-links /var/www/html/pypiserver/packages pypiserver
Ignoring indexes: https://pypi.python.org/simple
Collecting pypiserver
Installing collected packages: pypiserver
Successfully installed pypiserver-1.2.0
(pypiserver)[root@ws2 env]$ pypi-server -p 8080 /var/www/html/pypiserver/packages
10.0.0.31 - - [11/Jun/2017 21:11:57] "GET /simple/pip/ HTTP/1.1" 200 397
10.0.0.31 - - [11/Jun/2017 21:11:57] "GET /packages/pip-8.1.1.tar.gz HTTP/1.1" 200 1139175
```

#### Test from client machine

```
[root@app1 tmp]$ cat ~/.pip/pip.conf
[global]
index-url = http://yumrepo:8080/simple/
trusted-host = yumrepo
[root@app1 tmp]$ 
[root@app1 tmp]$ pip install pip==8.1.1
Collecting pip==8.1.1
  Downloading http://yumrepo:8080/packages/pip-8.1.1.tar.gz (1.1MB)
    100% |████████████████████████████████| 1.1MB 28.8MB/s 
Installing collected packages: pip
  Found existing installation: pip 9.0.1
    Uninstalling pip-9.0.1:
      Successfully uninstalled pip-9.0.1
  Running setup.py install for pip ... done
Successfully installed pip-8.1.1
[root@app1 tmp]$ 
```


### References

- [https://pypiserver.readthedocs.io/en/latest/](https://pypiserver.readthedocs.io/en/latest/)
- [https://pypi.python.org/pypi](https://pypi.python.org/pypi)
