.data
size: .word 5   #t1
sum: .word 0    #t2
vect: .word 1, 2, 3, 4, 5 #primera direccion: t0

.text
	la t0, vect # *vect = t0, se carga solo la direccion, el lw no hace falta pq no se carga un valor
	la t1, size 
	lw t1, 0(t1)
	la t2, sum
	lw t2, 0(t2)
	
	li t3, 0 #index de bucle
loop:	bge t3, t1, exit #Salta a exit si i >= size  (for int i = 0; i < size; ++)
	lw t4, 0(t0)
	add t2, t2, t4 
	addi t0, t0, 4 # pasar a siguiente elem del vect (sumar 4 a la direccion) 
	addi t3, t3, 1 #i++
	j loop
exit:
	la t5, sum 
	sw t2, 0(t5) # cargar resultado en t2
	
	
	li a7, 10
	ecall
