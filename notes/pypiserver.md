
## pypiserver Setup

```
yum install python-pip libffi-devel gcc python-devel openssl-devel
pip install --upgrade setuptools
```

```
pip install --no-index --find-links . setuptools-36.0.1.zip
```

```
yum install python-virtualenv
mkdir ~/env ; cd ~/env
virtualenv pypiserver
source pypiserver/bin/activate
```

```
pip install --no-index --find-links . pypiserver-1.2.0.zip
pypi-server -p 8080 /var/www/html/pypiserver/packages
```

```
deactivate
```

#### References

- [https://pypiserver.readthedocs.io/en/latest/](https://pypiserver.readthedocs.io/en/latest/)
