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
	buffer resb 64  ; Buffer para almacenar cadenas

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
	call printstr
	lea rdi, [baseSol]
	call printstr
	call readint
	mov [base], rax  ; Guardar la base seleccionada

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
	cmp qword [operacion], 1
	je suma
	cmp qword [operacion], 2
	je resta
	cmp qword [operacion], 3
	je multiplicacion
	cmp qword [operacion], 4
	je division
	lea rdi, [saltoLinea]
	call printstr
	lea rdi, [opcionInvOperacion]
	call printstr
	lea rdi, [saltoLinea]
	call printstr
	jmp _start

suma:
	;Sumar números
	mov rax, [num1]
	mov rbx, [num2]
	ADD rax, rbx
	mov [resultado], rax
	jmp mostrarResultado

resta:
	;Restar números
	mov rax, [num1]
	mov rbx, [num2]
	sub rax, rbx
	mov [resultado], rax
	jmp mostrarResultado

multiplicacion:
	;Multiplicar números
	mov rax, [num1]
	mov rbx, [num2]
	IMUL rax, rbx
	mov [resultado], rax
	jmp mostrarResultado

division: ;Division tiene problemas
	mov rax, [num1]
	mov rbx, [num2]

	;verificar si el divisor es 0
	cmp rbx, 0
	je divisionPorCero

	;dividir números
	IDIV rbx
	mov [resultado], rax
	jmp mostrarResultado

divisionPorCero:
	lea rdi, [msgDivPorCero]
	call printstr
	lea rdi, [saltoLinea]
	call printstr
	jmp _start

mostrarResultado:
	; Mostrar resultado en la base seleccionada
	mov rax, [resultado]   ; Cargar el resultado
	mov rbx, [base]        ; Cargar la base seleccionada

	; Verificar base seleccionada y mostrar resultado
	cmp rbx, 1
	je mostrarBinario
	cmp rbx, 2
	je mostrarOctal
	cmp rbx, 3
	je mostrarDecimal
	cmp rbx, 4
	je mostrarHexadecimal
	jmp salir

mostrarBinario:
	lea rdi, [resultadoMsg]
	call printstr
	mov rdi, [resultado]
	call printbin  ; Llamado para imprimir en binario
	lea rdi, [saltoLinea]
	call printstr
	jmp mostrarSalida

mostrarOctal:
	lea rdi, [resultadoMsg]
	call printstr
	mov rdi, [resultado]
	call printoct  ; Llamado para imprimir en octal
	lea rdi, [saltoLinea]
	call printstr
	jmp mostrarSalida

mostrarDecimal:
	lea rdi, [resultadoMsg]
	call printstr
	mov rdi, [resultado]
	call printint  ; Llamado para imprimir en decimal
	lea rdi, [saltoLinea]
	call printstr
	jmp mostrarSalida

mostrarHexadecimal:
	lea rdi, [resultadoMsg]
	call printstr
	mov rdi, [resultado]
	call printhex  ; Llamado para imprimir en hexadecimal
	lea rdi, [saltoLinea]
	call printstr
	jmp mostrarSalida

printbin:
    ; Convierte el número en rdi a binario y lo imprime
	; Aquí puedes implementar la lógica de conversión y mostrar bit por bit
	ret

printchar:
    ; RDI contiene el carácter a imprimir
	mov rax, 1              ; syscall: sys_write
	mov rdi, 1              ; file descriptor: stdout (1 = salida estándar)
	mov rsi, rsp            ; usar la pila para el carácter
	sub rsp, 1              ; reservar 1 byte en la pila
	mov [rsp], dil          ; almacenar el carácter en la pila (dil = 8 bits de rdi)
	mov rdx, 1              ; tamaño de 1 byte
	syscall                 ; llamada al sistema
	add rsp, 1              ; restaurar la pila
	ret                     ; regresar de la función

printoct:
	mov rax, rdi        ; Copiamos el número en rax
	mov rbx, 8          ; Base octal
	mov rcx, 22         ; Máximo 22 dígitos octales para un número de 64 bits

	lea rsi, [buffer+22] ; Apuntar al final del buffer
	mov byte [rsi], 0   ; Final de cadena

printoct_loop:
	test rax, rax
	jz printoct_done    ; Si ya terminamos de convertir, salir

	xor rdx, rdx
	div rbx             ; Dividir entre 8, el resto queda en rdx
	add dl, '0'         ; Convertir el valor en dígito ASCII
	dec rsi
	mov [rsi], dl       ; Guardar el dígito en el buffer
	jmp printoct_loop

printoct_done:
	lea rdi, [rsi]
	call printstr       ; Imprimir la cadena octal
	ret

printhex:
	mov rax, rdi        ; Copiamos el número en rax
	mov rbx, 16         ; Base hexadecimal
	mov rcx, 16         ; Máximo 16 dígitos hexadecimales para un número de 64 bits

	lea rsi, [buffer+16] ; Apuntar al final del buffer
	mov byte [rsi], 0   ; Final de cadena

printhex_loop:
	test rax, rax
	jz printhex_done    ; Si ya terminamos de convertir, salir

	xor rdx, rdx
	div rbx             ; Dividir entre 16, el resto queda en rdx
	cmp dl, 9
	jle printhex_digit  ; Si el valor es 0-9, convertir a dígito ASCII
	add dl, 'A' - 10    ; Si es A-F, ajustar al código ASCII
	jmp printhex_store

printhex_digit:
	add dl, '0'         ; Convertir a carácter ASCII

printhex_store:
	dec rsi
	mov [rsi], dl       ; Guardar el dígito en el buffer
	jmp printhex_loop

printhex_done:
	lea rdi, [rsi]
	call printstr       ; Imprimir la cadena hexadecimal
	ret

mostrarSalida:
	;Mostrar mensaje de salida
	lea rdi, [msgSalida]
	call printstr
	call readint
	cmp rax, 1
	je _start

salir:
	;Salir del programa
	mov eax, 1
	mov ebx, 0
	INT 0x80
