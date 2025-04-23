.include "dacio_def.s"

.text
	li s0, GPIOBASE
	
	li t0, 0x0000000F # leds 0-3 (botones rojos)
	sw t0, GPFSEL(s0) # selecciona 1:os de t0 como bits de salida

# bucle infinito que hace parpadear leds 0-3
# enciende, espera, apaga, espera (asi en bucle)
loop:	
	sw t0, GPSET(s0) # activa leds de 1:os de t0 (enciende)
	j esperar
volver:	sw t0, GPCLR(s0) # apaga leds de 1:os de t0 (apaga)
	j esperar2


esperar:
	li t1 500000
# bucle que espera (carga valor grande y decrementa 1 por iteración)
e1loop:	beqz t1, volver
	addi t1, t1, -1
	j e1loop
	
esperar2:
	li t1 500000
	
e2loop:	beqz t1, loop
	addi t1, t1, -1
	j e2loop
