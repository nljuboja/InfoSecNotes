# InfoSecNotes
## Recon/Passive Scanning
* CTF Scanning
  * netdiscover - Shows IP addresses as ARP requests go over the interface
```
netdiscover
```
  * arpscan - Sends out ARP scans and sees the responses
```
arpscan <ip_addr>.0/24
```
  * nmap - Intessive
```
nmap -A -T4 -o <output_file> <ip_addr>
```
* Showdan
  * ...
* Subdomain Enumeration
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
  * nmap - nmap scripts located at /usr/share/nmap/scripts
```
nmap --script http-enum.nse <ip_addr>
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
sqlmap -o -u <url of page> --forms --dbs
```
    * To show the tables in the database
```
sqlmap -o -u <url of page> --forms -D <database_name> --tables
```
    * Dump info from users table and try to crack password
```
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
## Privilege Escalation
* Windows
  * Useful site for living off the land https://lolbas-project.github.io/
* Linux
  * Useful site for living off the land https://gtfobins.github.io/
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
