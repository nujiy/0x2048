init:
	//������ǰ��Ԥ��512��ָ���λ�ã���ô�ҵ�������ʼ��ַ����4*512.
	addi $s6, $zero, 0x800		//s6:���16���������ݵ���ʼ��ַ.
	addi $t0, $zero, 0x1;
	sw $t0, 0($s6);
	sw $t0, 4($s6);
	sw $t0, 8($s6);
	sw $t0, 12($s6);
	addi $s5, $zero, 0x840 		//���α������е���ʼ��ַ
	addi $s4, $zero, 0x04;		//�Ƚϳ���4
	addi $a3, $zero, 0xFFFFD000;	//��Ű�����Ϣ�ĵ�ַ
	add $s7, $zero, $zero;
begin:
	lw $s1, 0($a3);			
	add $s7, $zero, $zero;		//s7�洢��һ�ΰ������Ƿ������µķ��顣
	beq $zero, $zero, tryright;
	
loop:
	//a0---ƫ���� ���ǵ�Ҫ��4�ı����� a1�����ж���4��ש�鲻�����жϲ���
	//a0 = -4. �ж����ơ��ص㣺mod 4 = 0. index & 0011 ==0000.
	//a0 = 4. �ж����ơ��ص㣺mod 4 = 3. index & 0011 ==0011.
	//a0 = -16. �ж����ơ��ص㣺div 4 = 0. index & 1100 ==0000.
	//a0 = 16. �ж����ơ��ص㣺div 4 = 3. index & 1100 ==1100.
	addi $t1, $zero, 1;		//t1 = i = 1,2,3
	loop1:
		beq $t1, $s4, exitloop;	// i=4���˳�ѭ��
			add $t2, $zero, $zero;	//t2 = j =0
			loop2:
				beq $t2, $s4,loop2end	//t2 = 4,�˳�ѭ��
					addi $t3, $zero, 0x0; 		//t3 = k = 0..3
					loop3:
							beq $t3, $s4, loop3end;
							add $t4, $zero, $t2;
							add $t4, $t4, $t4;
							add $t4, $t4, $t4;
							add $t4, $t4, $t3;	//�Ȱѵ�ǰ�����index�����
			
							addi $t5, $zero, -4;
							addi $t6, $zero, -16;
							if1:
								bne $a0, $t5,if2;
								addi $t8, $zero, 3;
								and $t7, $t4, $t8;
								beq $t7, $zero, jbreak;
								beq $zero, $zero, continue;
							if2:
								bne $a0, $s4,if3;
								addi $t8, $zero,3;
								and $t7, $t4, $t8;
								beq $t7, $t8, jbreak;
								beq $zero, $zero, continue;
							if3:
								bne $a0, $t6,if4;
								addi $t8, $zero, 0xc;
								and $t8, $t8, $t4;
								beq $t8,$zero, jbreak;
								beq $zero, $zero, continue; 
							if4:				
								addi $t8, $zero,0xc;
								and $t7, $t8, $t4;
								beq $t7, $t8, jbreak;
								beq $zero, $zero, continue;
					continue:

							add $t4, $t4, $t4;
							add $t4, $t4, $t4;
							add $t4, $t4, $s6;
							add $t8, $t4, $a0;	//��ƫ����
							lw $t5, 0($t4);
							lw $t6, 0($t8);
					jbreak:
							addi $t3, $t3, 1;
							bne $t6, $zero,  loop3;
							sw $zero, 0($t4);
							sw $t5, 0($t8);
							addi $t7, $t7, 1;
							beq $zero, $zero, loop3;
					loop3end:
				addi $t2, $t2, 1;
				beq $zero, $zero, loop2;
			loop2end:	
		addi $t1, $t1, 1;
		beq $zero, $zero, loop1;
	exitloop:
		jr $ra;


tryright:
	addi $t1, $zero, 0x0023;
	beq $s1, $t1, right;
	bne $s1, $t1, tryleft;

right:
	addi $a0, $zero, 4;
	jal loop;

		add $t1, $zero, $zero;			//t1 = 0..3
		right2loop1:
			beq $t1, $s4, right2loop1exit;	
				addi $t2, $zero, 3;	//t2 = 3..1
				right2loop2:
					beq $t2,$zero,right2loop2end;
					add $t4, $zero, $t1;
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $t4, $t2;
					addi $t4, $t4, -1;	//t2ʵ���ϴ�2..0
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $s6, $t4;
					lw $t5, 0($t4);
					lw $t6, 4($t4);
					addi $t2, $t2, -1;
					bne $t5, $t6, right2loop2;
					beq $t5, $zero, right2loop2;
					sw $zero, 0($t4);
					addi $t6, $t6,1;
					sw $t6, 4($t4);
					beq $zero, $zero, right2loop2; 
				right2loop2end:
			addi $t1, $t1, 1;
			beq $zero, $zero, right2loop1;			
		right2loop1exit:

	jal loop;
	beq $zero, $zero, done;		

tryleft:
	addi $t1, $zero, 0x001C;
	beq $s1, $t1, left;
	bne $s1, $t1, tryup;

left:
	addi $a0, $zero, -4;
	jal loop;

		add $t1, $zero, $zero;			//t1 = 0..3
		left2loop1:
			beq $t1, $s4, left2loop1exit;	
				addi $t2, $zero, 1;	//t2 = 1..3
				left2loop2:
					beq $t2,$s4,left2loop2end;
					add $t4, $zero, $t1;
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $t4, $t2;
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $s6, $t4;
					lw $t5, 0($t4);
					lw $t6, -4($t4);
					addi $t2, $t2, 1;
					bne $t5, $t6, left2loop2;
					beq $t5, $zero, left2loop2;
					sw $zero, 0($t4);
					addi $t6, $t6,1;
					sw $t6, -4($t4);
					beq $zero, $zero, left2loop2; 
				left2loop2end:
			addi $t1, $t1, 1;
			beq $zero, $zero, left2loop1;			
		left2loop1exit:

	jal loop;
	beq $zero, $zero, done;		


tryup:
	addi $t1, $zero, 0x001D;
	beq $s1, $t1, up;
	bne $s1, $t1, trydown;

up:
	addi $a0, $zero, -16;
	jal loop;

		add $t1, $zero, $zero;			//t1 = 0..3
		up2loop1:
			beq $t1, $s4, up2loop1exit;	
				addi $t2, $zero, 1;	//t2 = 1..3
				up2loop2:
					beq $t2,$s4,up2loop2end;
					add $t4, $zero, $t2;
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $t4, $t1;
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $s6, $t4;
					lw $t5, 0($t4);
					lw $t6, -16($t4);
					addi $t2, $t2, 1;
					bne $t5, $t6, up2loop2;
					beq $t5, $zero, up2loop2;
					sw $zero, 0($t4);
					addi $t6, $t6,1;
					sw $t6, -16($t4);
					beq $zero, $zero, up2loop2; 
				up2loop2end:
			addi $t1, $t1, 1;
			beq $zero, $zero, up2loop1;			
		up2loop1exit:

	jal loop;
	beq $zero, $zero, done;		


trydown: 
	addi $t1, $zero, 0x001B;
	beq $s1, $t1, down;
	bne $s1, $t1, done;

down:
	addi $a0, $zero, 16;
	jal loop;

		add $t1, $zero, $zero;			//t1 = 0..3
		down2loop1:
			beq $t1, $s4, down2loop1exit;	
				addi $t2, $zero, 3;	//t2 = 3..1
				down2loop2:
					beq $t2,$zero,down2loop2end;
					add $t4, $zero, $t2;
					addi $t4, $t4, -1;	//ʵ����t2��2..0 
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $t4, $t1;
					add $t4, $t4, $t4;
					add $t4, $t4, $t4;
					add $t4, $s6, $t4;
					lw $t5, 0($t4);
					lw $t6, 16($t4);
					addi $t2, $t2, -1;
					bne $t5, $t6, down2loop2;
					beq $t5, $zero, down2loop2;
					sw $zero, 0($t4);
					addi $t6, $t6,1;
					sw $t6, 16($t4);
					beq $zero, $zero, down2loop2; 
				down2loop2end:
			addi $t1, $t1, 1;
			beq $zero, $zero, down2loop1;			
		down2loop1exit:

	jal loop;
	beq $zero, $zero, done;		

done:
	//����s7�����Ƿ������µ�ש��
	beq $zero, $zero, begin;