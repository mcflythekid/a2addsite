# a2addsite

Create a new apache2 vhost with light speed

### Installation / Upgrade ###

```bash
cd ~
rm -rf a2addsite
git clone https://github.com/mcflythekid/a2addsite.git
sudo cp -rf ./a2addsite/a2addsite.sh /usr/local/bin/a2addsite
sudo chmod +x /usr/local/bin/a2addsite
sudo a2addsite

```
### Usage ###

```bash
$ sudo a2asite domain_name [\"alias_name1 alias_name2\"]
```
### Example ###

Only domain

```bash
$ sudo a2asite example.com
```
Domain and alias

```bash
$ sudo a2asite example.com www.example.com
```
Domain and 2 aliases

```bash
$ sudo a2asite example.com "www.example.com www2.example.com"
```
