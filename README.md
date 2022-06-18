# Habitat

Simple collection of shell commands for managing apache2 websites.

### How it started

Used Laravel Homestead so far but i dislike VirtualBox, which in fact corrupted my Homestead VM by unknown reason and I lost my dev environment. Decided i will use Ubuntu in VMWare Workstation but had to manage dev sites somehow... and here we go!


### How to use


#### 1. Create website

Signature: `create-website.sh DOMAIN PHP_VERSION`

```
sudo ./create-website.sh starter.test 7.4
```

#### 2. Delete website            

Signature: `delete-website.sh DOMAIN DELETE_FILES=0`

```
sudo ./delete-files.sh starter.test 1
```

#### 3. Install specific PHP version            

Signature: `install-php.sh PHP_VERSION`

```
sudo ./install-php.sh 7.4
```


### Roadmap
- Add proper output to the scripts and surpress their outputs
- Add more scripts for deleting sites, disabling sites, etc.
- Add database management scripts
- etc...

### Contributions

Feel free to contribute
