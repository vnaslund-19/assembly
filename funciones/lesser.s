.data
tam: .word 10
vector: .word 1, 2, 3, 4, 1, 2, 1, 2, 5, 6
val: .word 3
res: .word 0

.text
	la a0, vector # en a0 cargamos direccion del vector
	la a1, tam 
	lw a1, 0(a1) # en a1 el tamaño del vector
	la a2, val
	lw a2, 0(a2) # en a2 el valor
	jal lesser # llamamos a la funcion
	la a1, res 
	sw a0, 0(a1) # almacenamos en res el valor devuelto por la funcion (a0)
	li a7, 10
	ecall

lesser: # aqui tu funcion
	li t0, 0 # resultado que se va incrementando
loop:	beqz a1, exit # exit cuando size == 0
	lw t1, 0(a0) # cargar valor de vector en t1
	addi a0, a0, 4 # pasar a siguiente posicion de vector
	addi a1, a1, -1 # size--
	blt t1, a2, incrementar # si valor < que param: incrementar
	j loop

incrementar:
	addi t0, t0, 1
	j loop
	
exit:	mv a0, t0 # Mover resultado a direccion de retorno
	ret 
	