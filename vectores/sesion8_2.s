.data
tam: .word 8 #t1
pos: .word 0 #t2
vector: .word 2, -3, 6, 5, -3, 8, 1, 0 #t0
val: .word -4 #t3

.text
.global main
main:
	la t0, vector # vect=t0, se carga solo la direccion, el lw no hace falta pq no se carga un valor
	la t1, tam
	lw t1, 0(t1)
	la t2, pos
	li t2, -1 # pos == -1 si no encontrado (subject)
	la t3, val
	lw t3, 0(t3)

	li t4, 0 # indice
loop:	
	bge t4, t1, exit # salir si i >= tam
	lw t5, 0(t0) # cargar valor de vect en t5
	beq t5, t3, update_pos
	addi t0, t0, 4 # pasar a siguiente posicion del vect (sumar 4 a la dir)
	addi t4, t4, 1 #i++ 
	j loop

update_pos:
	mv t2, t4 # cargar indice de bucle en pos
	j exit # lw t2, 0(t4), esto interpretaria lo que hay en t4 como una dir de mem
	
exit:
	la t5, pos # cargar en registro auxiliar (no usado)
	sw t2, 0(t5) # store en pos
	li a7, 10
	ecall