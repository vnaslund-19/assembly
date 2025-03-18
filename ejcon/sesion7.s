#emular codigo de alto nivel:

#int fib = 0;

#int n = 5;
#int ant1 = 0;
#int ant2 = 1;

#for (int i = 0; i < n; i++) 
#{
#  fib = ant1 + ant2;
#  ant1 = ant2;
#  ant2 = fib;
#} 
#fib = ant1;

.data
fib: .word 0 # t0
n: .word 8 # t3

.text
	la t0, fib
	lw t0, 0(t0)
	la t3, n
	lw t3, 0(t3)
	
	li t1, 0 # t1 == ant1
	li t2, 1 # t2 == ant2
	
	li t4, 0 #loop index
loop:	bge t4, t3, exit
	add t0, t1, t2
	add t1, t2, x0
	add t2, t0, x0
	addi t4, t4, 1
	j loop
exit:
	add t0, t1, x0
	la t5, fib 
	sw t0, 0(t5) # cargar resultado en t0
	
	li a7, 10
	ecall 
	
	