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
  * dirb
  * wfuzz
  * gobuster
```
./gobuster -u <url> -w <wordlist> -t 10
# With Subdomain list
./gobuster -m dns -w <subdomain_file> -u <url> -i
```
  * nmap - nmap scripts located at /usr/share/nmap/scripts
```
nmap --script http-enum.nse <ip_addr>
```
* Masscan
```
masscan -iL <ip_addr_file> --rate 10000 -p1-65535 --only-open -oL <output_file>
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
```
## Exploitation
* Reverse Shells
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
  * sqlmap
    * To test for injection
```
# Checks for injection and databases
sqlmap -o -u <url of page> --forms --dbs
# To show the tables in the database
sqlmap -o -u <url of page> --forms -D <database_name> --tables
# Dump info from users table and try to crack password
sqlmap -o -u <url of page> --forms -D <database_name> -T <table_name> --dump
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
## Resources
* Tips tools and guides in https://github.com/swisskyrepo/PayloadsAllTheThings
