;Calculadora en NASM x86 para Linux

section .data

	; Mensajes
	msg db "Elige la operación: 1. Suma, 2. Resta, 3. Multiplicacion, 4. Division", 0xA
	lenMsg equ $-msg

	operacionMsg db "Ingresa la operación: ", 0xA
	lenOperacionMsg equ $-operacionMsg

	baseMsg db "En que base deseas el resultado: 1. Binario, 2. Octal, 3. Decimal, 4. Hexadecimal", 0xA
	lenBaseMsg equ $-baseMsg

	num1Msg db "Ingresa el primer numero (en base decimal): ", 0xA
	lenNum1Msg equ $-num1Msg

	num2Msg db "Ingresa el segundo numero (en base decimal): ", 0xA
	lenNum2Msg equ $-num2Msg

	resultadoMsg db "El resultado en decimal es: ", 0xA
	lenResultadoMsg equ $-resultadoMsg

	resBinarioMsg db "El resultado en binario es: ", 0xA
	lenResBinarioMsg equ $-resBinarioMsg

	resOctalMsg db "El resultado en octal es: ", 0xA
	lenResOctalMsg equ $-resOctalMsg

	resHexMsg db "El resultado en hexadecimal es: ", 0xA
	lenResHexMsg equ $-resHexMsg

section .bss
	operación resb 16
	base resb 16
	num1 resb 16
	num2 resb 16
	resultado resb 16

section .text
	global _start

_start:
	; Mostrar opciones de operaciones
	MOV eax, 4
	MOV ebx, 1
	MOV ecx, msg
	MOV edx, lenMsg
	INT 0x80

	; Solicitar operación
	MOV eax, 4
	MOV ebx, 1
	MOV ecx, operacionMsg
	MOV edx, lenOperacionMsg
	INT 0x80

	; Leer operación
	MOV eax, 3
	MOV ebx, 0
	MOV ecx, operación
	MOV edx, 1
	INT 0x80

	; Solicitar base
	MOV eax, 4
	MOV ebx, 1
	MOV ecx, baseMsg
	MOV edx, lenBaseMsg
	INT 0x80

	; Leer base
	MOV eax, 3
	MOV ebx, 0
	MOV ecx, base
	MOV edx, 1
	INT 0x80

	; Solicitar primer número
	MOV eax, 4
	MOV ebx, 1
	MOV ecx, num1Msg
	MOV edx, lenNum1Msg
	INT 0x80

	; Leer primer número
	MOV eax, 3
	MOV ebx, 0
	MOV ecx, num1
	MOV edx, 16
	INT 0x80

	; Solicitar segundo número
	MOV eax, 4
	MOV ebx, 1
	MOV ecx, num2Msg
	MOV edx, lenNum2Msg
	INT 0x80

	; Leer segundo número
	MOV eax, 3
	MOV ebx, 0
	MOV ecx, num2
	MOV edx, 16
	INT 0x80

	;Salir del programa
	MOV eax, 1
	MOV ebx, 0
	INT 0x80


