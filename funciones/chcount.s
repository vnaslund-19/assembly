.data
res: .word 0
cadena: .asciz "Hola, esto es una prueba"
char: .ascii "a"

.text
main:
	la a0, cadena # en a0 cargamos direccion de la cadena
	la a1, char 
	lb a1, 0(a1) # en a1 el caracter a buscar
	jal chcount # llamamos a la funcion
	la a1, res 
	sw a0, 0(a1) # almacenamos en res el valor devuelto por la funcion (a0)
	li a7, 10
	ecall
 
chcount: # aqui tu funcion
	lb t0, 0(a0) # a0 es la cadena (la primera direccion de la cadena al principio), esto carga el primer caracter en t0
	li t1, 0 # count = 0
	
loop:	beqz t0, exit # si valor de la cadena es 0, nulo, se acabo la cadena
	beq t0, a1, incrementar # si char actual = char a buscar
volver:	addi a0, a0, 1 # siguiente direccion de cadena
	lb t0, 0(a0) # cargar valor de vect en t0
	j loop
	
incrementar:
	addi t1, t1, 1
	j volver

exit:	mv a0, t1 # mover count a registro de retorno
	ret
