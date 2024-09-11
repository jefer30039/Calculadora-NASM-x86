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
	msgBaseInvalida: db 'Base inválida, inténtelo de nuevo.', 10, 0

section .bss
	operacion: resq 1 ; Almacena la operación a realizar
	base: resq 1 ; Almacena la base del resultado
	num1: resq 1 ; Almacena el primer número (operando)
	num2: resq 1 ; Almacena el segundo número (operando)
	resultado: resq 1 ; Almacena el resultado
	buffer resb 65  ; Buffer para almacenar cadenas

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
	MOV rax, [num1]
	MOV rbx, [num2]

	;verificar si el divisor es 0
	CMP rbx, 0
	JE divisionPorCero

	;dividir números
	xor rdx, rdx
	DIV rbx
	MOV [resultado], rax
	JMP mostrarResultado
	
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
	
	lea rdi, [msgBaseInvalida]
	call printstr
	lea rdi, [saltoLinea]
	call printstr
	jmp _start

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
    mov rax, rdi          ; Cargar el número en rax (número a convertir)
    mov rcx, 64           ; Máximo 64 bits para representación binaria
    lea rsi, [buffer + 64]; Apuntar al final del buffer (64 bytes)
    mov byte [rsi], 0     ; Añadir un terminador nulo al final del buffer

    ; Verificar si el número es 0
    test rax, rax
    jnz printbin_loop     ; Si el número no es 0, proceder con la conversión
    ; Si el número es 0, imprimir directamente '0'
    dec rsi
    mov byte [rsi], '0'
    jmp printbin_done

printbin_loop:
    ; Asegúrate de no sobrepasar el inicio del buffer
    cmp rsi, buffer       ; Verificar si hemos alcanzado el inicio del buffer
    jb printbin_done      ; Si `rsi` ha alcanzado el inicio, terminar la conversión

    dec rsi               ; Mover el puntero del buffer hacia atrás
    xor rdx, rdx          ; Limpiar rdx para la división
    mov rbx, 2            ; Cargar el divisor 2 en rbx
    div rbx               ; Dividir el número en rax entre 2
    add dl, '0'           ; Convertir el bit (0 o 1) a carácter ASCII
    mov [rsi], dl         ; Guardar el bit en el buffer
    test rax, rax         ; Verificar si el cociente es 0
    jnz printbin_loop     ; Si no es 0, continuar dividiendo

printbin_done:
    lea rdi, [rsi]        ; Apuntar a la cadena binaria en el buffer
    call printstr_bin     ; Imprimir la cadena binaria
    ret

printstr_bin:
    mov rdx, 0       ; Reiniciar el contador de longitud
count_chars:
    cmp byte [rdi+rdx], 0  ; Verificar si llegamos al terminador nulo
    je  done_counting
    inc rdx
    jmp count_chars

done_counting:
    mov rax, 1       ; sys_write
    mov rsi, rdi     ; Puntero a la cadena
    mov rdi, 1       ; File descriptor para salida estándar (stdout)
    syscall          ; Llamar al sistema
    ret

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
