;Calculadora en NASM x86 para Linux

%include 'util.asm' ;biblioteca de funciones básicas

section .data
	; Mensajes
	msg: db "Elige la operación: 1. Suma, 2. Resta, 3. Multiplicación, 4. División", 10, 0
	msgSalida: db "¿Desea realizar otra operación? 1. Sí, 2. No", 10, 0
	operacionMsg: db "Ingresa la operación a realizar: ", 0
	baseMsg: db 'En qué base deseas el resultado: 1. Binario, 2. Octal, 3. Decimal, 4. Hexadecimal', 10, 0
	baseSol: db 'Ingresa la base: ', 0
	num1Msg: db 'Ingresa el primer número (en base decimal): ', 0
	num2Msg: db 'Ingresa el segundo número (en base decimal): ', 0
	resultadoMsg: db 'El resultado es: ', 0
	opcionInvOperacion: db 'Ingresó una operación inválida, inténtelo de nuevo.', 10, 0
	saltoLinea: db 10, 0
	msgDivPorCero: db 'No se puede dividir por 0', 10, 0

section .bss
	operacion: resq 1 ; Almacena la operación a realizar
	base: resq 1 ; Almacena la base del resultado
	num1: resq 1 ; Almacena el primer número (operando)
	num2: resq 1 ; Almacena el segundo número (operando)
	resultado: resq 1 ; Almacena el resultado

section .text
	global _start

_start:
	; Mostrar opciones de operaciones
	lea rdi, [msg]
	call printstr

	; Solicitar operación
	lea rdi, [operacionMsg]
	call printstr
	call readint
	mov [operacion], rax


	; Solicitar base
	lea rdi, [baseMsg]
	;call printstr
	lea rdi, [baseSol]
	;call printstr
	;call readint
	mov [base], rax

	; Solicitar primer número
	lea rdi, [num1Msg]
	call printstr 
	call readint ; Lee un entero de la entrada estándar y lo almacena en rax
	mov [num1], rax ; Guardar el primer número en num1

	; Solicitar segundo número
	lea rdi, [num2Msg]
	call printstr
	call readint ; Lee un entero de la entrada estándar y lo almacena en rax
	mov [num2], rax ; Guardar el segundo número en num2

	; Realizar operación
	CMP qword [operacion], 1
	JE suma
	CMP qword [operacion], 2
	JE resta
	CMP qword [operacion], 3
	JE multiplicacion
	CMP qword [operacion], 4
	JE division
	lea rdi, [saltoLinea]
	call printstr
	lea rdi, [opcionInvOperacion]
	call printstr
	lea rdi, [saltoLinea]
	call printstr
	JMP _start

suma:
	;Sumar números
	MOV rax, [num1]
	MOV rbx, [num2]
	ADD rax, rbx
	MOV [resultado], rax
	JMP mostrarResultado

resta:
	;Restar números
	MOV rax, [num1]
	MOV rbx, [num2]
	SUB rax, rbx
	MOV [resultado], rax
	JMP mostrarResultado

multiplicacion:
	;Multiplicar números
	MOV rax, [num1]
	MOV rbx, [num2]
	IMUL rax, rbx
	MOV [resultado], rax
	JMP mostrarResultado

division: ;Division tiene problemas
	;Dividir números
	MOV rax, [num1]
	MOV rbx, [num2]
	;verificar si el divisor es 0
	CMP rbx, 0
	JE divisionPorCero
	IDIV rbx
	MOV [resultado], rax
	JMP mostrarResultado

divisionPorCero:
	lea rdi, [msgDivPorCero]
	call printstr
	lea rdi, [saltoLinea]
	call printstr
	JMP _start

mostrarResultado:
	; Mostrar resultado en decimal
	lea rdi, [resultadoMsg]
	call printstr
	mov rdi, [resultado]
	call printint
	lea rdi, [saltoLinea]
	call printstr

	;Mostrar mensaje de salida
	lea rdi, [msgSalida]
	call printstr
	call readint
	CMP rax, 1
	JE _start

salir:
	;Salir del programa
	MOV eax, 1
	MOV ebx, 0
	INT 0x80


