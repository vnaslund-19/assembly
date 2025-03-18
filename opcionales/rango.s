.data
datos:      .word 8,-3,4,-7,9,-7,6,-1 # t0
len:        .word 8 # t1
res:        .word 0 # t2

 
.text
.global main
main:
	la t0, datos # se carga solo la direccion, el lw no hace falta pq no se carga un valor (dir de memoria de un vector)
	la t1, len  # cargar dir de memoria de len en t1
	lw t1, 0(t1) # usar dir previamente cargada para acceder a valor en memoria
	la t2, res
	lw t2, 0(t2)
	
	lw t3, 0(t0) # t3 = max, cargar primer valor de vector en max y min
	lw t4, 0(t0) # t4 = min
	
	li t5, 1 # t5 es indice de bucle
	
loop:	bge t5, t1, exit
	addi t0, t0, 4 # pasar a siguiente dir de vect
	addi t5, t5, 1 # indice++
	lw t6, 0(t0) # cargar valor actual de vect en t6
	bgt t6, t3, make_max_t6 # si valor > max salta
	blt t6, t4, make_min_t6 # si valor < min salta
	j loop # volver a bucle IMP
	
make_max_t6:
	mv t3, t6 # mover valor en t6 a t3
	j loop
	
make_min_t6:
	mv t4, t6
	j loop
	
exit:	sub t2, t3, t4 # res = max - min
	la a0, res # cargar dir de res en t5
	sw t2, 0(a0) # almacenar valor en t2 (res local) en la dir almacenada en t5

	li a7, 10
	ecall
	
	
	
	
	
