.include "dacio_def.s"

.text
	li s0, GPIOBASE

	li s4, 0b00001111111101111111000000000000 # leds 12-18 y 20-26 (numeros
	sw s4, GPFSEL(s0) # selecciona 1:os de t0 como bits de salida

	li s1, 0x10000000 # bit 28, boton de sumar
	li s2, 0x20000000 # bit 29, boton de volver a empezar

	j reset
loop:
	lw t4, GPLEV(s0)  # cargar valores del puerto GPLEV en t4 (leer estado de leds)
	and t5, s1, t4    # aplicar mascara de SUMAR (s1) y guardar en t4
	bnez t5, sumar # el and funciona tal que solo mira si 28 == 1, si no lo es t4 = 0
	and t5, s2, t4   # aplicar mascara de RESET (s2) y guardar en t4
	bnez t5, reset   # salta solo si t4 no es 0 (bit 29 == 1)
	j loop

sumar:
	# bucle que espera (carga valor grande y decrementa 1 por iteración)
	# si no se buggea y registra muchas clicks por click
    	li   t6, 35000  
esperar:
    	addi t6, t6, -1
    	bnez t6, esperar
    
	addi s3, s3, 1
	li   t0, 100
	bgeu s3, t0, reset # si llega a 100, volver a empezar por 00
	j pintar

reset:
	li s3, 0
	jal apagar
	jal dig0o
	jal digo0
	j loop

pintar:
	jal apagar         # limpia todos los LEDs

	li t0, 10
	divu t1, s3, t0    # t1 = 1 dig (num / 10)
	remu t2, s3, t0    # t2 = 2 dig (num % 10)

	# -----------------------
	# Pintar primer dígito (t1)
	# -----------------------
	li t0, 0
	beq t1, t0, call_dig0o
	li t0, 1
	beq t1, t0, call_dig1o
	li t0, 2
	beq t1, t0, call_dig2o
	li t0, 3
	beq t1, t0, call_dig3o
	li t0, 4
	beq t1, t0, call_dig4o
	li t0, 5
	beq t1, t0, call_dig5o
	li t0, 6
	beq t1, t0, call_dig6o
	li t0, 7
	beq t1, t0, call_dig7o
	li t0, 8
	beq t1, t0, call_dig8o
	li t0, 9
	beq t1, t0, call_dig9o

call_dig0o: jal dig0o
	j pintar_2
call_dig1o: jal dig1o
	j pintar_2
call_dig2o: jal dig2o
	j pintar_2
call_dig3o: jal dig3o
	j pintar_2
call_dig4o: jal dig4o
	j pintar_2
call_dig5o: jal dig5o
	j pintar_2
call_dig6o: jal dig6o
	j pintar_2
call_dig7o: jal dig7o
	j pintar_2
call_dig8o: jal dig8o
	j pintar_2
call_dig9o: jal dig9o
	j pintar_2

# -----------------------
# Pintar segundo dígito (t2)
# -----------------------
pintar_2:
	li t0, 0
	beq t2, t0, call_digo0
	li t0, 1
	beq t2, t0, call_digo1
	li t0, 2
	beq t2, t0, call_digo2
	li t0, 3
	beq t2, t0, call_digo3
	li t0, 4
	beq t2, t0, call_digo4
	li t0, 5
	beq t2, t0, call_digo5
	li t0, 6
	beq t2, t0, call_digo6
	li t0, 7
	beq t2, t0, call_digo7
	li t0, 8
	beq t2, t0, call_digo8
	li t0, 9
	beq t2, t0, call_digo9

call_digo0: jal digo0
	j loop
call_digo1: jal digo1
	j loop
call_digo2: jal digo2
	j loop
call_digo3: jal digo3
	j loop
call_digo4: jal digo4
	j loop
call_digo5: jal digo5
	j loop
call_digo6: jal digo6
	j loop
call_digo7: jal digo7
	j loop
call_digo8: jal digo8
	j loop
call_digo9: jal digo9
	j loop

# pinta el primer digito
dig0o:
	li t3, 0b00000000000000111111000000000000 # 0: leds 12-17
	sw t3, GPSET(s0)
	ret
dig1o:
	li t3, 0b00000000000000000110000000000000 # 1: leds 13-14
	sw t3, GPSET(s0)
	ret
dig2o:
	li t3, 0b00000000000001011011000000000000 # 2: leds 12,13,15,16,18
	sw t3, GPSET(s0)
	ret
dig3o:
	li t3, 0b00000000000001001111000000000000 # 3: leds 12,13,14,15,18
	sw t3, GPSET(s0)
	ret
dig4o:
	li t3, 0b00000000000001100110000000000000 # 4: leds 13,14,17,18
	sw t3, GPSET(s0)
	ret
dig5o:
	li t3, 0b00000000000001101101000000000000 # 5: leds 12,14,15,17,18
	sw t3, GPSET(s0)
	ret
dig6o:
	li t3, 0b00000000000001111101000000000000 # 6: leds 12,14,15,16,17,18
	sw t3, GPSET(s0)
	ret
dig7o:
	li t3, 0b00000000000000000111000000000000 # 7: leds 12,13,14
	sw t3, GPSET(s0)
	ret
dig8o:
	li t3, 0b00000000000001111111000000000000 # 8: leds 12-18
	sw t3, GPSET(s0)
	ret
dig9o:
	li t3, 0b00000000000001101111000000000000 # 9: leds 12,13,14,15,17,18
	sw t3, GPSET(s0)
	ret

# Pintan el segundo digito
digo0:
	li t3, 0b00000011111100000000000000000000 # 0: leds 20-25
	sw t3, GPSET(s0)
	ret
digo1:
	li t3, 0b00000000011000000000000000000000 # 1: leds 21-22
	sw t3, GPSET(s0)
	ret
digo2:
	li t3, 0b00000101101100000000000000000000 # 2: leds 20,21,23,24,26
	sw t3, GPSET(s0)
	ret
digo3:
	li t3, 0b00000100111100000000000000000000 # 3: leds 20,21,22,23,26
	sw t3, GPSET(s0)
	ret
digo4:
	li t3, 0b00000110011000000000000000000000 # 4: leds 21,22,25,26
	sw t3, GPSET(s0)
	ret
digo5:
	li t3, 0b00000110110100000000000000000000 # 5: leds 20,22,23,25,26
	sw t3, GPSET(s0)
	ret
digo6:
	li t3, 0b00000111110100000000000000000000 # 6: leds 20,22,23,24,25,26
	sw t3, GPSET(s0)
	ret
digo7:
	li t3, 0b00000000011100000000000000000000 # 7: leds 20,21,22
	sw t3, GPSET(s0)
	ret
digo8:
	li t3, 0b00000111111100000000000000000000 # 8: leds 20-26
	sw t3, GPSET(s0)
	ret
digo9:
	li t3, 0b00000110111100000000000000000000 # 9: leds 20,21,22,23,25,26
	sw t3, GPSET(s0)
	ret


apagar:
	sw s4, GPCLR(s0) # apaga leds de 1:os de s4 (todos de los numeros)
	ret
