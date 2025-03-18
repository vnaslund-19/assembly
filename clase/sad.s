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
	li t0, 0 # sum  (init a 0)
loop:	beqz a2, exit    # exit cuando a2==0 (decreciendo size hasta llegar a 0)
	lw t1, 0(a0)     # cargar valor de posicion de vect1 actual en t1
	addi a0, a0, 4   # incrementa 1 pos de vector
	lw t2, 0(a1)     # cargar valor de posicion de vect2 actual en t2
	addi a1, a1, 4   # incrementa 1 pos de vector
	addi a2, a2, -1  # i--
	sub t3, t1, t2   # cargar valor de resta en t3
	bgez t3, cont    # si positivo saltarse paso de *= -1
	sub t3, zero, t3 # convertir a valor abs (zero == x0 == 0)
cont:	add t0, t0, t3
	j loop
	
exit:	mv a0, t0   # mover suma a registro de return (espificado en subject)
	ret 
