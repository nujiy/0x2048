//11-0 R,G,B
//19-16,15-12 <,>
//23-20 Y
//24    move
main:
	add $t0, $zero, $zero; 		//t0 ��ǰѭ������
	addi $s0, $zero, 0x0100;		//s0 ��ǰ����һ������
						//s1 ������ȡ���ӣ�s2 = s0 * 4
	add $s3, $zero, $zero;		//s3 ��һ���Ƿ��û��ո��
	add $s4, $zero, $zero;		//s4 ��һ���Ƿ��û��س���
	addi $s5, $zero, 0x0007;		//s5  Y����
	addi $s6, $zero, 0x3000;         //s6  speed
	addi $s7, $zero, 0x0006;		//s7  ĳ���Ƚϳ���

	addi $t1, $zero, 0x03E8;
	lw $a0, 0($t1);			//0xD0000000	���̵�ַ
	lw $a1, 4($t1);			//0xFF0FFFFF �Ƚϳ���
	lw $a2, 8($t1);			//0x01000000	�л�״̬��Խ����ǰ������ӣ�
	lw $a3, 12($t1);			//0x000007FC	debug��ַ
	lw $t6, 16($t1);			//0x000F0000	��ȡ�����Ӹ߶�
	lw $t7, 20($t1);			//0x0000F000	��ȡ�����Ӹ߶�
	

Always: 
	add $s2, $s0, $s0
	add $s2, $s2, $s2
	lw  $s1, 0($s2);
	and $s1, $s1, $a1;

	add $t1, $s5, $s5;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;

	or $s1, $s1, $t1;
	sw $s1, 0($s2);

Check:
	addi $t3, $zero, 0x0003;
	and $t5, $s0, $t3;
	xor $t5, $t5, $t3;
	//�������� 100-3, 101-2, 102-1, 103-0 �����Ϳ���bne 0��ת��
	//����ʵ�� 100-3, 101-4, 102-5, 103-6 ��֪��������ɶ��ֻ�ܽ���ʹ�
	//���ﱾӦ����һ�� beq���ƶ��������ˡ�

	lw  $s1, 0($s2);
	and $t2, $s1, $t7;
	
	add $t1, $s5, $s5;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;

	slt $t3, $t1, $t2;

	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	add $t1, $t1, $t1;
	
	and $t2, $s1, $t6;
	slt $t4, $t2, $t1;

	and $t3, $t3, $t4;
	bne $t5, $s7, Tryup;         
	//��仰����Ӧ�������棬Ϊ���ٶ�һ�·�������
	beq $t3, $zero, Gameover;

Tryup:
	
	lw $s1, 0($a0); 
	addi $t1, $zero, 0x0029;		//space
	beq $s1, $t1, Up;
	add $s3, $zero, $zero;
	bne $s1, $t1, Trydown;

Up:
	bne $s3, $zero, Trydown;
	addi $s3, $s3, 1;
	beq $s5, $zero, Gameover;
	addi $s5, $s5, -1;

Trydown:
	lw $s1, 0($a0); 
	addi $t1, $zero, 0x005A;		//enter
	beq $s1, $t1, Down;
	add $s4, $zero, $zero;
	bne $s1, $t1, Mustdown;
Down:
	bne $s4, $zero, Mustdown;
	addi $s4, $s4, 1;
	slti $t1, $s5, 14;
	beq $t1, $zero, Gameover;
	addi $s5, $s5, 1;

Mustdown:
	addi $t0, $t0, 1;
	slt $t1, $t0, $s6;
	bne $t1, $zero, Always;

	add $t0, $zero, $zero;
	addi $s6, $s6, -0x0030;		//speed up
	
	lw $s1, 0($s2);
	xor $s1, $s1, $a2;
	sw $s1, 0($s2);

	addi $s0, $s0, 1;
	slti $t1, $s0, 0x0200;
	bne $t1, $zero, NotMod;
	addi $s0, $zero, 0x0100;
NotMod:
	slti $t1, $s5, 14;
	beq $t1, $zero, Gameover;
	addi $s5, $s5, 1;
	j Always;
Gameover:
Deadloop:
	j Deadloop;
	j Deadloop;
