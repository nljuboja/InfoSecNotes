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
* Integer Type Conversion Table (Source on Left, Destination on Top)

Data Type | signed char | unsigned char | short int | unsigned short int | int | usigned int
--- | --- | --- | --- | --- | --- | ---
signed char | compatible types | value changing - bit pattern same | value preserving - sign extension | value changing - sign extension | value preserving - sign extension | value changing - sign extension
unsigned char | value changing - bit pattern same - implementation defined | compatible types | value preserving - zero extension | value preserving - zero extension | value preserving - zero extension | value preserving - zero extension | value preserving | zero extension
short int | value changing - truncation - implementation defined | value chaning - truncation | compatible types | value changing - bit pattern same | value changing - sign extension | value changing - sign extension 
unsigned short int | value changing - truncation - implementation defined | value changing - truncation | value changing - bit pattern sam - implementation defined | compatible types | value preserving - zero extension | value preserving - zero extension
int | value changing - truncation - implementation defined | value changing - truncation | value changing - truncation - implementation defined | value changing - truncation | compatible types | value changing - bit pattern same
unsigned int | value changing - truncation - implementation defined | value changing - truncation | value changing - truncation - implementation defined | value changing - truncation | value changing - bit pattern same - implementation defined | compatible types

* Integer Promotion
  * If an integer type is narrower than an int, integer promotions almost always convert it to an int

Source Type | Result Type | Rationale
--- | --- | ---
unsigned char | int | Promote; source rank less than int rank
char | int | Promote; source rank less than int rank
short | int | Promote; source rank less than int rank
unsigned short | int | Promote; source rank less than int rank
unsigned int:24 | int | Promote; bit field of unsigned int
unsigned int:32 | unsigned int | Promote; bit field of unsigned int
int | int | Don't promote; source rank equal to int rank
unsigned int | unsigned int | Don't promote; source rank equal to int rank
long int | long int | Don't promote; source rank greater then int rank
float | float | Don't promote; source not of integer type
char * | char * | Don't promote; source not of integer type

* Unary + Operator
  * Performs integer promotion on its operand
* Unary - Operator
  * Performs integer promotion on its operand and then does negation event if value is signed after the promotion
* Usual Arithmetic Conversion Examples
Left Operand Type | Right Operand Type | Result | Common Type
--- | --- | --- | ---
int | float | 1. Left operand converted to float | float
double | char | 1. Right oeprand converted to double | double
unsigned int | int | 1. Right operand converted to unsigned int | unsigned int
unsigned short | int | 1. Left operand converted to int | int
unsigned char | unsigned short | 1. Left operand converted to int 2. Right operand converted to int | int
unsigned int:32 | short | 1. Left operand converted to unsigned int 2. Right operand converted to int 3. Right operand conveted to unsigned int | unsigned int
unsigned int | long int | 1. Left operand converted to unsigned long int 2. Right operand conveted to unsigned long int | unsigned long it
unsigned int | long long int | 1. Left operand converted to long long int | long long int
unsigned int | unsigned long long int | 1. Left operand converted to unsigned long long int | unsigned long long int

* Default Type Promotion

Operation | Operand Types | Conversion | Resulting Type
--- | --- | --- | ---
Typecast (type)expression | | Expression is converted to type using simple conversions | Type
assignment= | | Right operand converted to left operand type using simple conversions | Type of left operand
Function call with prototype | | Arguments converted using simple conversions according to prototype | Return type of function
Function call without prototype | | Arguments promoted via default argument promotions, which are essentially integer promotions | int
Return Unary +,- | Operant must be arithmetic type | Operand unergoes integer promosions | Promoted type of operand
+a | | | |
-a | | | |
~a | | | |
Unary ~ ~a | Operand must be integer type | Operand undergoes integer promotions | Promoted type of operand
Bitwise << and >> | Operand must be integer type | Operands undergo integer promotions | Promoted type of left operand
switch statement | Expression must have integer type | Expression undergoes integer promotion; cases are converted to that type | 
Binary +,- | Operands must be arithmetic type| Operands undergo usual arithmetic conversions | Common type from usual arithmetic conversions
Binary + and / | Operands must be arithmetic type | Operands undergo usual arithmetic conversions | Common type from usual arithmetic conversions
Binary % | Operands must be integer type | Operands undergo usual arithmetic conversions | Common type from usual arithmetic conversions
Binary subscritp [] a[b] | | Interpreted as * ((a)+(b)) | 
Unary ! | Operand must be arithmetic type or pointer | | int, value 0 or 1
sizeof | | | size_t (unsigned integer type)
Binary < > <= => == != | Operands must be arithmetic type | Operands undergo usual arithmetic conversions | int, value 0 or 1

* Assembly Signed and Unsigned Comparisons
  * jl is for signed comparison
  * jb is for unsigned comparison
  
Instruction | Description | signed-ness | Flags
--- | --- | --- | ---
JO | Jump if overflow | | OF = 1 
JNO | Jump if not overflow | | OF = 0
JS | Jump if sign | | SF = 1
JNS | Jump if not sign | | SF = 0
JE,JZ | Jump if equal,Jump if zero | | ZF = 1
JNE,JNZ | Jump if not equal, Jump if not zero | | ZF = 0
JB,JNAE,JC | Jump if below, Jump if not above or equal, Jump if carry | unsigned | CF = 1
JNB,JAE,JNC | Jump if not below, Jump if above or equal, Jump if not carry | unsigned | CF = 0
JBE,JNA | Jump if below or equal, Jump if not above | unsigned | CF = 1 or ZF = 1
JA,JNBE | Jump if above,Jump if not below or equal | unsigned | CF = 0 and ZF = 0
JL,JNGE | Jump if less, Jump if not greater or equal | signed | SF <> OF
JGE,JNL | Jump if greater or equal, Jump if not less | signed | SF = OF
JLE,JNG | Jump if less or equal, Jump if not greater | signed | ZF = 1 or SF <> OF
JG,JNLE | Jump if greater, Jump ifn ot less or equal | signed | ZF = 0 and SF = OF
JP,JPE | Jump if parity, Jump if parity even | | PF = 1
JNP,JPO | Jump if not parity, Jump if parity odd | | PF = 0
JCXZ|JECXZ | Jump if %CX register 0, Jump if %ECX register is 0 | | %CX = 0, %ECX = 0

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
