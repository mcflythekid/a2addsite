# a2addsite

Create a new apache2 vhost with light speed

### Installation ###

```bash
cd ~
rm -rf tmp_a2addsite
git clone https://github.com/mcflythekid/a2addsite.git tmp_a2addsite
sudo cp -rf ./tmp_a2addsite/a2addsite.sh /usr/local/bin/a2addsite
sudo chmod +x /usr/local/bin/a2addsite
a2addsite
```
### Usage ###

```bash
$ sudo a2addsite add domain_name [\"alias_name1 alias_name2\"]
$ sudo a2addsite del domain_name
```
### Upgrade new version ###
```bash
$ sudo a2addsite upgrade
````
### Example ###

```bash
$ sudo a2addsite add example.com
$ sudo a2addsite add example.com   www.example.com
$ sudo a2addsite add example.com   "www.example.com www2.example.com"
$ sudo a2addsite del example.com
```
