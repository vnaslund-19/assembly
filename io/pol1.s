.include "dacio_def.s"

.text
	li s0, GPIOBASE

	li t0, 0b00000101101100111111000000000000 # numero 02, leds 12-17 y 20,21,23,24,26
	sw t0, GPFSEL(s0) # selecciona 1:os de t0 como bits de salida
	sw t0, GPSET(s0) # activa leds de 1:os de t0
	