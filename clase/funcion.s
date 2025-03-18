.data
size: .word 5
vect: .word 1, 2, 3, 4, 5 #primera direccion: t0

.text
	la a0, vect # *vect = t0, se carga solo la direccion, el lw no hace falta pq no se carga un valor
	li a1, 3
	jal sum #fucntion call
	mv s0, a0
	
	la a0, vect2
	li a1, 2
	jal sum
	
	li a7, 10
	ecall
#vectSumLoop en una function	
sum: #param1: a0, param2: a1
	li t0, 0 #s=0
	li t1, 0 #i=0
sum_loop:
	bge t1, a1, sum_exit
	lw t2, 0(a0)
	add t0, t0, t2 #s += t2
	add a0, a0, 4 #pasar a siguiente posicion de vector
	addi t1, t1, 1 #i++
	j sum_loop
sum_exit:
	mv a0, t0 
	ret # returns to where funct was called