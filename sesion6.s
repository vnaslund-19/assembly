# Programa calculando la media de 4 notas
.data

nota1: .word 7 # t0
nota2: .word 8 # t1
nota3: .word 6 # t2
nota4: .word 5 # t3
media: .word 0 # t4

.text
	la  t0, nota1 # cargar etiquetas en registros
	lw  t0, 0(t0)
	la  t1, nota2
	lw  t1, 0(t1)
	la  t2, nota3
	lw  t2, 0(t2)
	la  t3, nota4
	lw  t3, 0(t3)
	la  t4, media
	lw  t4, 0(t4)
	
	add t0, t0, t1 # sumar todo a t0
	add t0, t0, t2
	add t0, t0, t3
	
	# cargar media en t4
	srai t4, t0, 2 # shift 2 a la derecha = dividir por 4 (a = arithmetic, conserva signo. Ahora funciona con nums negativos)
	
	la t5, media 
	sw t4, 0(t5) # cargar resultado en media (t5)
	
	
	li a7, 10
	ecall