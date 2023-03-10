#// ---------------------------------------------------------
#// Dado um vetor A, pesquisa entre elementos, de A[Prim]
#// até A[Ult] pelo valor chave, usando pesquisa binária.
#//
#// Pré-condições: 0<=Prim, Ult<=Tam-1, onde Tam é o tamanho
#// total do Vetor A e A[Prim]<=A[Prim+1]<=...<=A[Ult],
#// ou seja, o vetor já está ordenado em ordem crescente.
#//
#// Pós-condição: Se chave existe no vetor A, retorna
#// o índice do vetor igual a chave, senão retorna -1.
#//
#// Lembre-se: 1) Assume-se A como um vetor de inteiros
#// 2) Prim e Ult são índices, valores naturais
#// 3) chave é um inteiro.
#// ---------------------------------------------------------
# int binary_search(int A[], int Prim, int Ult, int Chave){ 
#     int mid;
#     if (Prim > Ult){ 
#         return -1; 
#     }

#     mid = (Prim + Ult) / 2;

#     if (A[mid] == Chave){ 
#         return mid;
#     }

#     else if (A[mid] > Chave){ 
#         return (binary_search(A, Prim, mid - 1, Chave));
#     }

#     else if (A[mid] < Chave){ 
#         return (binary_search(A, mid + 1, Ult, Chave));
#     }
# }	
	
	.text
	.globl	main

main:	la	$t1, vet	#carrega endere�o para o vetor.
	li	$t2, 0		#seta o indice inicial para 0.
	la	$t3, size	#carrega o endereco do indice final.
	lw	$t3, 0($t3)	#seta o indice final conforme tamanho do vetor declarado em size.
	la	$t4, alvo	#carrega o endereco do elemento alvo.
	lw	$t4, 0($t4)	#carrega ultimo parametro que eh o valor que queremos buscar o indice.
	addiu	$sp, $sp,-20	#abre pilha com 5 posicoes para passar os parametros.
	sw	$ra, 0($sp)	#carrega endereco de retorno no primeiro parametro (S0) para pilha.
	sw	$t1, 4($sp)	#carrega endereco do vetor para pilha.
	sw	$t2, 8($sp)	#carrega indice do primeiro elemento.
	sw	$t3, 12($sp)	#carrega indice do ultimo elemento.
	sw	$t4, 16($sp)    #carrega elemento alvo para buscarmos o indice.
	jal	binary_search   #pula para a rotina aninhada denominada binary_search.
	lw	$ra, 0($sp)	#recebe o ultimo endere�o de retorno da pilha.
	lw	$a0, 4($sp)	#recebe o resultado que esta armazenado no segundo par�metro da pilha.
	addiu	$sp, $sp, 20	#desaloca as ultimas 5 posicoes da pilha.
	li	$v0, 1		
	syscall			#realiza o print do resultado que trata-se do indice do elemento alvo.
	li	$v0 ,10
	syscall			#encerra o programa.
				
binary_search:	
	lw	$t0, 0($sp)	#carrega o endere�o de retorno do topo da pilha.
	lw	$t1, 4($sp)	#carrega o endere�o de in�cio do vetor. 
	lw	$t2, 8($sp)	#carrega o indice de inicio do vetor.
	lw	$t3, 12($sp)	#carrega o indice do final do vetor.
	lw	$t4, 16($sp)	#carrega todos objetos da pilha enviada.
	blt	$t3,$t2,teste3	#testa se a ultima posicao do vetor eh menor que a primeira posicao, caso seja verdadeiro vai para a rotina aninhada teste3.
	li	$a1, 2		#declara um divisor para poder pegar a metade do numero.
	addu	$t5, $t2, $t3	#soma o parametro do primeiro indice com o parametro do ultimo indice.
	div	$t5, $t5, $a1 	#realiza divisao para obtermos o indice do meio e guardar em t5.
	li	$t6, 4		#seta para 4 o registrador t6 para podermos realizar a multiplicacao com o intuito de chegarmos ao endereco do meio.
	mult	$t5, $t6   	#multiplica 4 x indice do meio.
	mflo	$t7  		#guarda multiplicacao em t7.
	addu	$t7, $t7, $t1  	#realiza a soma do endereco inicial do vetor com o resultado do t7 para assim chegarmos no endereco do indice do meio.
	lw	$t7, 0($t7)   	#carrega o elemento do indice do meio em t7.
	bne	$t7, $t4, teste1 #testa se o elemento do meio eh diferente do alvo, caso seja ele vai para a rotina aninhada teste1.
	lw	$ra, 0($sp)	#caso alvo seja igual ao endereco do meio, carrega o endereco de retorno do topo da pilha em $ra.
	addiu	$sp,$sp,20	#desaloca os ultimos 5 espacos da pilha.
	sw	$t5, 4($sp)	#guarda o resultado no segundo parametro da pilha.
	jr	$ra		#retorna ao endere�o abaixo da ultima chamada jal realizada.
	
teste1: blt	$t7, $t4, teste2 #verifica se elemento do meio eh menor que o endereco alvo, caso seja salta para teste2..
	addi	$t5, $t5, -1	 #caso elemento do meio seja maior, diminui indice do meio.
	addiu	$sp,$sp,-20  	 #aloca mais 5 posicoes na pilha.
	sw	$ra, 0($sp)	 #guarda endereco de retorno da ultima chamada recursiva.
	sw	$t1, 4($sp)	 #guarda endereco de inicio do vetor.
	sw	$t2, 8($sp)	 #guarda indice de inicio do vetor.
	sw	$t5, 12($sp)	 #guarda indice do final do vetor(meio - 1).
	sw	$t4, 16($sp)	 #guarda elemento alvo.
	jal	binary_search	 #chamada recursiva em binary_search.
	lw	$ra, 0($sp)	 #carrega endereco de retorno do topo da pilha.
	lw	$t5, 4($sp)	 #carrega resultado com o intuito de nao perde-lo ao retirar mais 5 posicoes da pilha.
	addiu	$sp,$sp,20	 #desaloca 5 posicoes da pilha.
	sw	$t5, 4($sp)	 #guarda resultado novamente.
	jr	$ra		 #retorna ao endere�o abaixo da ultima chamada jal realizada.

teste2: addi	$t5, $t5, 1 	#caso elemento do meio seja menor, soma indice do meio.
	addiu	$sp,$sp,-20	#aloca mais 5 posicoes na pilha.
	sw	$ra, 0($sp)	#guarda endereco de retorno da ultima chamada recursiva.
	sw	$t1, 4($sp)	#guarda endereco de inicio do vetor.
	sw	$t5, 8($sp)	#guarda indice de inicio do vetor(meio+1).
	sw	$t3, 12($sp)	#guarda indice do final do vetor.
	sw	$t4, 16($sp)	#guarda elemento alvo.
	jal	binary_search	#chamada recursiva em binary search.
	lw	$ra, 0($sp)	#carrega endereco de retorno do topo da pilha.
	lw	$t5, 4($sp)	#carrega resultado com o intuito de nao perde-lo ao retirar mais 5 posicoes da pilha.
	addiu	$sp,$sp,20	#desaloca 5 posicoes da pilha.
	sw	$t5, 4($sp)	#guarda resultado novamente.
	jr	$ra		#retorna ao endereco abaixo da ultima chamada jal realizada.
	
teste3: li	$t8, -1		#carrega o valor -1 para o registrador $t8.
	sw	$t8,4($sp)	#carrega o valor de $t8 para a posicao de retorno da pilha.
	jr	$ra		#retorna ao endereco abaixo da ultima chamada jal realizada.



		.data
vet:		.word -5 -1 5 9 12 15 21 29 31 58 250 325
size:		.word 11
alvo:		.word 58
