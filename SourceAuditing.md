# Source Auditing
## Vulnerabilities
### Buffer Overflow
* Static Buffer Overflow
  * Mitigations
    * Stack canary/cookie
    * Non executable stack
    * ASLR
    * DEP
* Heap Buffer Overflow
  * Need to be familiar with the heap management in order to exploit
  * Hope that a function pointer is overwritten
  * Unlink exploit
  * Mitigations
    * Heap management hardening
* Off By One - Length calulcation of array is incorrect by one array element
  * Normally fails to account for null terminator or the way array indexing works
  * Could help in overflowing one byte or the least significant byte of a pointer
* Global/Static Data Overflow - stored in different data segments
* Vulnerable libc Functions
  * sprintf, memcpy, strcpy, strlen
### Areas to Exploit
* Function pointers
* Global Offset Table (GOT)/Process Linkage Table(PLT) in Unix ELF binarires
* Exit Handlers
* Lock Pointers in Windows
* Exception Handler routines in Windows (SEH)
