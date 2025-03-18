.data
vector1: .word 8,3,4,2,5,7,6,1
vector2: .word 4,3,5,6,5,4,6,0
size:    .word 8
res:     .word 0

.text
main:
 la a0, vector1  # en a0 cargamos direccion del vector1
 la a1, vector2  # en a1 cargamos dirección del vector2
 la a2, size
 lw a2, 0(a2)    # en a2 el numero de elementos de los vectores 
 call sad        # llamamos a la funcion
 la a1, res 
 sw a0, 0(a1)    # almacenamos en res el valor devuelto por la funcion (a0)
 li a7, 10
 ecall           # llamada para finalizar programa

sad: # aqui tu funcion
	li t0, 0  # indice de bucle
	li t4, 0  # t4 == sum
	
loop:	bge t0, a2, exit  # if i >= size exit
	lw t1, 0(a0)     # cargar valor de vector1 en t1
	addi a0, a0, 4   # pasar a siguiente pos de vector1
	lw t2, 0(a1)     # cargar valor de vector2 en t2
	addi a1, a1, 4   # pasar a siguiente pos de vector2
	sub t3, t1, t2   # resultado de resta en t3
	bltz t3, vabs_t3 # si t3 < 0 convertir a pos
volver: add t4, t4, t3
	addi t0, t0, 1   # i++
	j loop           # volver a bucle IMP

vabs_t3:
	sub t3, zero, t3 # t3 = 0 - t3 (zero == x0 (alias))
	j volver

exit:
	mv a0, t4 # mover sum (t4) a valor de retorno
	ret # return