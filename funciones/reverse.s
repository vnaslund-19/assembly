.data
vector1:  .word 1,2,3,4,5,6,7,8
vector2:  .word 0,0,0,0,0,0,0,0
len:      .word 8
 
.text
	la a0, vector1
	la a1, len
	lw a1, 0(a1)
	la a2, vector2
	jal reverse
	li a7, 10
	ecall
 
reverse:  # aqui tu funcion
	li t0, 4 
	mul t1, a1, t0 # cargar longitud*4 en t1 para sumarlo al vector
	addi, t1, t1, -4 # moverlo al principio del octavo valor en vez de estar fuera del vector
	add, a0, a0, t1 #llevar al ultimo valor vect[7]

loop:	beqz a1, exit #cuando size = 0
	lw t2, 0(a0) #cargar valor actual de src en t2
	sw t2, 0(a2) #cargar t2 en pos actual del destino
	addi a2, a2, 4 # pasar a siguiente de vector dst
	addi a0, a0, -4 # retrodecer en vector origen
	addi a1, a1, -1 #size--
	j loop

exit:	ret 
	
