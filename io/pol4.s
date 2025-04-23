.include "dacio_def.s"

.text
	li s0, GPIOBASE
	li s1, TIMERBASE
	
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
	lw t1, MTIME_LO(s1)
 	addi t1, t1, 500 #medio segundo
# bucle que espera 0,5s
e1loop:	lw t2, MTIME_LO(s1)
 	bgtu t2, t1, volver # si t2 (tiempo actual) es mayor que tiempo al principio + 500, salta 
 	j e1loop


esperar2:
	lw t1, MTIME_LO(s1)
 	addi t1, t1, 500 #medio segundo
# bucle que espera 0,5s
e2loop:	lw t2, MTIME_LO(s1)
 	bgtu t2, t1, loop # si t2 (tiempo actual) es mayor que tiempo al principio + 500, salta
 	j e2loop

