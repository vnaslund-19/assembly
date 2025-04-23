.data
__digitos__: .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111, 0, 0

.text
    j __skip__
task:	# configurar pines de los displays 7seg
	li s0, GPIOBASE
	li s1, 0x0FFFF000
	lw t0, GPFSEL(s0)
	or t0, t0, s1
	sw t0, GPFSEL(s0)
	
	li s2, 0	# contador unidades
	li s3, 0	# contador decenas
	
__loop__:	# borrar displays
	sw s1, GPCLR(s0)
	# mostrar estado de cuenta actual
	la t0, __digitos__
	add t1, t0, s3
	lb t1, (t1)
	slli t1, t1, 12
	add t2, t0, s2
	lb t2, (t2)
	slli t2, t2, 20
	or t1, t1, t2
	sw t1, GPSET(s0)
	
	jal __wait__

__inc__:	# incrementamos contador segundos
	addi s2, s2, 1
	li t0, 10
	bne s2, t0, __loop__
	li s2, 0
	addi s3, s3, 1
	bne s3, t0, __loop__
	li s3, 0
	j __loop__

__wait__:	# esperar 1 segundo
 	li t0, TIMERBASE
 	lw t3, MTIME_LO(t0)
 	lw t2, MTIME_HI(t0)
 	addi t1, t3, 1000
 	bgeu t1, t3, __wloop1__
 	addi t2, t2, 1
__wloop1__: lw t3, MTIME_HI(t0)
 	bltu t3, t2, __wloop1__
__wloop2__: lw t3, MTIME_LO(t0)
 	bltu t3, t1, __wloop2__
	ret
	
__skip__:
		
