# a2addsite

Create a new apache2 vhost with light speed

### Installation / Upgrade ###

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
$ sudo a2asite add domain_name [\"alias_name1 alias_name2\"]
$ sudo a2asite del domain_name
```
### Example ###

Only domain

```bash
$ sudo add a2asite example.com
```
Domain and alias

```bash
$ sudo a2asite add example.com www.example.com
```
Domain and 2 aliases

```bash
$ sudo a2asite add example.com "www.example.com www2.example.com"
```
Delete a domain

```bash
$ sudo a2asite del example.com
```
