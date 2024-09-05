section .data
	msg db "Elige la operación: 1. Suma, 2. Resta, 3. Multiplicacion, 4. Division", 0xA
	lenMsg equ $-msg

	operacionMsg db "Ingresa la operación: ", 0xA
	lenOperacionMsg equ $-operacionMsg

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

