.include "dacio_def.s"

.text
main:
	li s0, GPIOBASE
loop:	lw t0, GPLEV(s0) # leemos estado de los GPIOS
	li t1, 0x40000000 # PB2, bit 30 a 1
	and t1, t1, t0
	beqz t1, loop
	
parpadeo:	
	li t1, 0x00000400
	sw t1, GPFSEL(s0)
	sw t1, GPSET(s0)
	
	li s1, TIMERBASE
	lw t2, MTIME_LO(s1)
	addi t2, t2, 500
reta1:	lw t0, MTIME_LO(s1)
	bltu t0, t2, reta1
	
	lw t2, MTIME_LO(s1)
	addi t2, t2, 500
reta2:	lw t0, MTIME_LO(s1)
	bltu t0, t2, reta2

	j parpadeo
	
	li a7, 10
	ecall

	
	
