#emular codigo de alto nivel:
#int opcion;
#int res = 0;

#...

#switch (opcion) {
#  case 0: 
#    res = 0;
#    break;
#  case 1:
#    res = opcion;
#    break;
#  case 2:
#    res = res + opcion;
#    break;
#  case 3:
#    res = -opcion;  #NO BREAK, falls through to default
#  default:
#    res = res & opcion;
#}

.data
res: .word 0    #t0
opcion: .word 2 #t1

.text
	la t0, res
	lw t0, 0(t0)
	la t1, opcion
	lw t1, 0(t1)

	beqz t1, case0 #go to case 0 if opcion == 0
	
	li t2, 1
	beq t1, t2, case1
	
	li t2, 2
	beq t1, t2, case2
	
	li t2, 3
	beq t1, t2, case3
	
	j default
	
case0:	li t0, 0
	j exit
	
case1:	addi t0, t1, 0 # res = opcion + 0, (could use pseudo: mv t0, t1 )
	j exit
	
case2:	add t0, t0, t1
	j exit

case3:	sub t0, x0, t1 #t0 = 0 - t1 (could use pseudo: neg t0, t1)
	#No jump/break just as in high level code

default: and t0, t0, t1 #res = res & opcion;
	
exit:	la t3, res 
	sw t0, 0(t3) # cargar resultado en t0

	li a7, 10
	ecall