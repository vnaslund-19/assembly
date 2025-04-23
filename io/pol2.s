.include "dacio_def.s"

.text
	li s0, GPIOBASE
	
	li t0, 0x0000000F # leds 0-3 (botones rojos)
	sw t0, GPFSEL(s0) # selecciona 1:os de t0 como bits de salida
	
	li t2, 0x10000000 # bit 28, boton de ENCENDER
	li t3, 0x20000000 # bit 29, boton de APAGAR
	
	
loop:	
	lw t1, GPLEV(s0)  # cargar valores del puerto GPLEV en t1 (leer estado de leds)
	and t4, t2, t1    # aplicar mascara de ENCENDER (t2) y guardar en t4
	bnez t4, encender # el and funciona tal que solo mira si 28 == 1, si no lo es t4 = 0
	and t4, t3, t1    # aplicar mascara de APAGAR (t3) y guardar en t4
	bnez t4, apagar   # salta solo si t4 no es 0 (bit 29 == 1)
	j loop

 

encender:
	sw t0, GPSET(s0) # activa leds de 1:os de t0
	j loop
	
apagar:
	sw t0, GPCLR(s0) # apaga leds de 1:os de t0
	j loop
