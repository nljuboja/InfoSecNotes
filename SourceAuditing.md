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
### Integer Under/Overflow
* Multiplication can lead to an integer overflow
* Integer types - Widening
  * If signed, compiler will use sign extension to keep the signedness
  * If unsigned, compiler will use zero extension
  * Usually keeps the value of the integer being converted
* Integer types - Narrowing
  * Doesn't always keep the value of the integer being converted
* Integer Conversion Table

Data Type | signed char | unsigned char | short int | unsigned short int | int | usigned int
--- | --- | --- | --- | --- | --- | ---
signed char | compatible types | value changing - bit pattern same | value preserving - sign extension | value changing - sign extension | value preserving - sign extension | value changing - sign extension
unsigned char | value changing - bit pattern same - implementation defined | compatible types | value preserving - zero extension | value preserving - zero extension | value preserving - zero extension | value preserving - zero extension | value preserving | zero extension
short int | value changing - truncation - implementation defined | value chaning - truncation | compatible types | value changing - bit pattern same | value changing - sign extension | value changing - sign extension 
unsigned short int | value changing - truncation - implementation defined | value changing - truncation | value changing - bit pattern sam - implementation defined | compatible types | value preserving - zero extension | value preserving - zero extension
int | value changing - truncation - implementation defined | value changing - truncation | value changing - truncation - implementation defined | value changing - truncation | compatible types | value changing - bit pattern same
unsigned int | value changing - truncation - implementation defined | value changing - truncation | value changing - truncation - implementation defined | value changing - truncation | value changing - bit pattern same - implementation defined | compatible types


### Areas to Exploit
* Function pointers
* Global Offset Table (GOT)/Process Linkage Table(PLT) in Unix ELF binarires
* Exit Handlers
* Lock Pointers in Windows
* Exception Handler routines in Windows (SEH)
### Misc
* Maximum Values for Integers

Data Type | 8-bit | 16-bit | 32-bit | 64-bit
--- | --- | --- | --- | ---
Minimum value (signed) | -128 | -32768 | -2147483648 | -9223372036854775808
Maximum value (signed) | 127 | 32767 | 2147483647 | 9223372036854775807
Minimum value (unsigned) | 0 | 0 | 0 | 0
Maximum value (unsigned) | 255 | 65535 | 4294967295 | 18446744073709551615
