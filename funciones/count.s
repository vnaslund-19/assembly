.data
vector: .word 1, 2, 3, 4, 1, 2, 1, 2, 5, 6, 0
val: .word 1
res: .word 0

.text

 main:
	la a0, vector # en a0 cargamos direccion del vector
	la a1, val
	lw a1, 0(a1) # en a1 el valor a buscar
	jal count # llamamos a la funcion
	la a1, res 
	sw a0, 0(a1) # almacenamos en res el valor devuelto por la funcion (a0)
 
	li a7, 10
	ecall

count: # aqui tu funcion
	lw t0, 0(a0) # a0 es el vector (la primera direccion del vector al principio), esto carga el primer valor del vector en t0
	li t1, 0 # count = 0
	
loop:	beqz t0, exit # t0 es el valor del vector
	beq t0, a1, incrementar # si valor actual = valor a buscar
volver:	addi a0, a0, 4 # siguiente direccion de vector
	lw t0, 0(a0) # cargar valor de vect en t0
	j loop
	

incrementar:
	addi t1, t1, 1
	j volver

exit:	mv a0, t1 # mover count a registro de retorno
	ret 

	