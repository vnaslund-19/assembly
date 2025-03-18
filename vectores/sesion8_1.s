.data
tam: .word 8 # t1
max: .word 0 # t2
vector: .word -2, -3, -6, -5, 4, -10, -1, 8 #primera direccion: t0

.text
.global main
main:
	la t0, vector # vect=t0, se carga solo la direccion, el lw no hace falta pq no se carga un valor
	la t1, tam
	lw t1, 0(t1)

	la t2, max
	lw t2, 0(t0) # cargar valor de primer valor en max
	addi t0, t0, 4 # pasar a siguiente posicion del vect (sumar 4 a la dir
	li t3, 1 # indice de bucle (empieza por 1 como ya se ha leido un valor
loop:	
	bge t3, t1, exit # salir si i >= tam
	lw t4, 0(t0) # cargar valor de vect en t4
	addi t0, t0, 4 # pasar a siguiente posicion del vect (sumar 4 a la dir)
	addi t3, t3, 1 #i++
	bge t4, t2, make_max 
	j loop

make_max:
	mv t2, t4
	j loop
	
exit:
	la t5, max # cargar en registro auxiliar (no usado)
	sw t2, 0(t5) # store en max
	li a7, 10
	ecall
	 