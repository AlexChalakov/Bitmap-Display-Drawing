.data

	explain:    .asciiz     "Options:\tColours:\n1 - cls\t\t1 - red\n2 - row\t\t2 - orange\n3 - col\t\t3 - yellow\n4 - logo\t4 - green\n5 - exit\t5 - blue\n"
	input:      .asciiz	"Select an option:"
	detail:	    .asciiz 	"Select colour/row/col:"
	distance:	.asciiz 	"Select distance:"
	direction:	.asciiz 	"Options: \nNorth: 1\nEast 2\nSouth: 3\nWest: 4\nSelect direction:"

	# defining every needed colour in the menu
	Black:    .word		0x00000000	#black
	Red:	.word		0x00ff0000	#red
	Orange:	.word		0x00ffa500	#orange
	Yellow:	.word		0x00ffff00	#yellow
	Green:	.word		0x00008000	#green
	Blue:	.word		0x000000ff	#blue
	White:	.word		0x00ffffff	#white
	
.text

# loading the colours into the registers
lw $t1, Black
lw $t2, Red
lw $t3, Orange
lw $t4, Yellow
lw $t5, Green
lw $t6, Blue
lw $t7, White

# We first should print out the menu, where all of our options are
# Goint to line 133
jal options

# First command
cls:
	# after we press 1 for cls, we need to print another string input field for colours
	addi $v0, $zero, 4
	la $a0, detail
	syscall
	
	# read string input
	# need to define colour with a number here
	li $v0, 5
	syscall
	
	# colouring the background in colour RED
	addi $a2, $zero, 1		# adding 1, like a matching number for our input register
	bne $a2, $v0, stop		# whenever the user input equals 1, as per the above command, we go further the loop
	lui $s0,0x1004			# adding the (start) heap address
	addi $a0,$t2,0			# adding the colour RED to the registers in the loop
	addi $t0,$s0,0
	lui $s1,0x100C			# adding the end address
	loopDraw:
	sw $a0,0($t0)			# stocking the colour at address $t0
 	addi $t0,$t0,4			# implementing by 4 bytes, which is a 'word', so that we capture the whole screen in this colour
	bne $t0,$s1,loopDraw		# looping when $t0 and $s1 are not equal, which colours our screen in the selected option
	j options
	
	stop:
	
	# colouring the background in colour ORANGE
	# the above comments for colour RED, apply for every other of the 4 colours - ORANGE, YELLOW, GREEN and BlUE
	# the logic is all the same, the only difference is the code for the colour and the user input
	addi $a2, $zero, 2
	bne $a2, $v0, stop2
	lui $s0, 0x1004
	addi $a0, $t3,0
	addi $t0, $s0,0
	lui $s1,0x100C
	loopDraw2:
	sw $a0,0($t0)
	addi $t0, $t0, 4
	bne $t0, $s1, loopDraw2
	j options
	
	stop2:
	
	# colouring the background in colour YELLOW
	addi $a2, $zero, 3
	bne $a2, $v0, stop3
	lui $s0, 0x1004
	addi $a0, $t4,0
	addi $t0, $s0,0
	lui $s1,0x100C
	loopDraw3:
	sw $a0,0($t0)
	addi $t0, $t0, 4
	bne $t0, $s1, loopDraw3
	j options
	
	stop3:
	
	# colouring the background in colour GREEN
	addi $a2, $zero, 4
	bne $a2, $v0, stop4
	lui $s0, 0x1004
	addi $a0, $t5,0
	addi $t0, $s0,0
	lui $s1,0x100C
	loopDraw4:
	sw $a0,0($t0)
	addi $t0, $t0, 4
	bne $t0, $s1, loopDraw4
	j options
	
	stop4:
	
	# colouring the background in colour BLUE
	addi $a2, $zero, 5
	bne $a2, $v0, stop5
	lui $s0, 0x1004
	addi $a0, $t6,0
	addi $t0, $s0,0
	lui $s1,0x100C
	loopDraw5:
	sw $a0,0($t0)
	addi $t0, $t0, 4
	bne $t0, $s1, loopDraw5
	j options
	
	stop5:
	
# drawLine: Procedure to draw vertical and horizontal lines
# Second command for HORIZONTAL LINE
row:
	# Press 2 for rows, we'd need the option template to decide on a ROW
	# options menu appears
	addi $v0, $zero, 4
	la $a0, detail
	syscall
	
	# read input for row
	# define from which row would the line start
	li $v0, 5
	syscall
	
	# draw a row
	move $t0, $v0
	addi $a0,$zero,0x0000 		# loading default colour
	
	#start location
	lui $s0, 0x1004			# loading the heap address
	mul $s3,$t0,2048		# multiplying by 512 * 4
	add $s1,$s0,$s3			# transferring the multiplication in the heap address
	
	#end location
	addi $s4,$s1,2048		# putting an end location to the loop

	loop:
	sw $a0,0($s1)			# reserving the colour at address $s1
	addi $s1,$s1,4			# adding a word of 4 bytes every time
	beq $s1,$s4,row2		# looping to see if $s1 = $s4, if not, loop again
	j loop
	
	row2:
	
	j options			# jumping to options again (menu)
	
# Third command for VERTICAL LINE
col:
	# Press 3 for columns, we'd need the option template to decide on a COL
	addi $v0, $zero, 4
	la $a0, detail
	syscall
	
	# read input for column
	# define from which column would the line start
	li $v0, 5
	syscall
	
	# draw a column
	move $t0, $v0
	addi $a0,$zero,0x0000		# loading default colour
	
	#start location
	lui $s0, 0x1004			# loading the heap address
	sll $s5,$t0,2			# shifting left logical by user input (col number) with 2*2
	add $s0,$s0,$s5			# transferring the sll in the heap address
	
	#end location
	addi $s7,$zero,0		# counter (mul causes address out of range)

	loop2:
	sw $a0,0($s0)			# reserving the colour at address $s0
	addi $s7,$s7,1			# incrementing the counter by 1, as it has to reach the targeted value at line 184
	addi $s0,$s0,2048		# incrementing $s0 by one row (512*4)
	beq $s7,256,col2		# looping to see if the counter, $s7 = 256, if not, loop again
	j loop2
	
	col2:
	
	j options			# jumping to options again (menu)
	
# logo: Draw a line with a specific start point and a fixed length
# Fourth command
logo:

	# after we press 4 for logo, we need to print another string input field for distance of the following command
	addi $v0, $zero, 4
	la $a0, distance
	syscall
	
	# read string input
	# need to define how long will the line be in pixels
	li $v0, 5
	syscall
	
	#after that we'd need the menu for the logo directions - N,S,E,W
	addi $v0, $zero, 4
	la $a0, direction
	syscall
	
	# read string input
	# need to define colour with a number here
	li $v0, 5
	syscall
	
main:

# Text
options:
	# print string explain
	addi $v0,$zero,4		# put syscall service into v0
	la $a0, explain			# put address of string (input) into a0
	syscall				# actually print string

	# print string input
	addi $v0, $zero, 4
	la $a0, input
	syscall

	# read string input
	# need to define the function with a number here
	li $v0, 5
	syscall
	
	# if the read input is equal to 1, we jump to operation cls (line 34)
	addi $a2, $zero,1
	bne $a2, $v0, stopOps	
	j cls
	
	stopOps:
	
	# if the read input is equal to 2, we jump to operation row (line 124)
	addi $a2, $zero, 2
	bne $a2, $v0, stopOps2
	j row
	
	stopOps2:
	
	# if the read input is equal to 3, we jump to operation col (line 159)
	addi $a2, $zero, 3
	bne $a2, $v0, stopOps3
	j col
	
	stopOps3:
	
	# if the read input is equal to 4, we jump to operation logo (line 195)
	addi $a2, $zero, 4
	bne $a2, $v0, stopOps4
	j logo
	
	stopOps4:
	
	# if the read input is equal to 5, we jump to operation exit (line 272)
	addi $a2, $zero, 5  
	bne $a2, $v0, stopOps5 
	j exit
	
	stopOps5:

	
exit:
	li $v0, 10
	syscall
	