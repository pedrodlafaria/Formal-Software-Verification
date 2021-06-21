/*Vari‡vel floor indica, em cada instante, o andar onde o elevador se encontra (o elevador comea o seu funcionamento no primeiro andar).*/

byte floor=1;

 

 
/*Seguem-se as vari‡veis ext1 e ext2, que se referem a pedidos externos feitos (pedidos de fora do elevador), que podem tomar os valores 1, 2, 3 (consoante o andar de onde o pedido foi feito) ou 0 (se n‹o existe nenhum pedido pendente).*/
/*ext1 Ž pedido externo priorit‡rio (n‹o existe pedido priorit‡rio no instante inicial).*/
/*ext2 Ž pedido externo secund‡rio (n‹o existe pedido secund‡rio no instante inicial).*/

byte ext1=0;
byte ext2=0;

 


/*Seguem-se as vari‡veis int1 e int2, que se referem a pedidos internos feitos (pedidos de dentro do elevador), que podem tomar os valores 1, 2, 3 (consoante o andar para onde os passageiros pretendem ir) ou 0 (se n‹o existe nenhum pedido pendente).*/
/*int1 Ž pedido interno priorit‡rio (n‹o existe pedido priorit‡rio no instante inicial).*/
/*int2 Ž pedido interno secund‡rio (n‹o existe pedido secund‡rio no instante inicial).*/

byte int1=0;
byte int2=0;

 

 
/*Vari‡vel open indica, em cada instante, se as portas est‹o abertas ou n‹o (o elevador comea o seu funcionamento com as portas abertas).*/

bool open=true;

 

 
/*Vari‡vel emptied indica, em cada instante, se o elevador est‡ vazio ou n‹o (o elevador comea o seu funcionamento vazio).*/

bool emptied=true;

 

 
/*mtype necess‡rio para a vari‡vel request, respons‡vel por indicar, em cada instante, se o pr—ximo pedido a ser respondido Ž interno ou externo (o elevador comea o seu funcionamento a dar prioridade aos pedidos internos).*/

mtype={internal, external};
mtype request=internal;

 

 
/*Vari‡vel internal_emission indica, ap—s chegada, se foi respondido algum pedido externo, caso em que se deve seguir obrigatoriamente um pedido interno. Inicialmente n‹o h‡ pedidos de qualquer tipo, em particular deste.*/

bool internal_emission=false;

 

 


/*Controlador, que emite pedidos externos ou internos.*/

active proctype Controller(){

do

/*Emiss‹o de pedidos externos. Esta parte Ž feita atomicamente para garantir que os pedidos externos surgem instantaneamente.*/

::atomic{
	if
	::ext1==0 ->
		if
  		::ext2!=0 && floor!=ext2 -> ext1=ext2; ext2=0; printf("Pedidos externos foram reordenados. S‹o agora para %d e depois para %d \n", ext1, ext2)
		::ext2==0 -> 
			if
			::emptied==true -> ext1=0; printf("NinguŽm chega \n")
			::
				if
				::floor==1 -> 
					if
					::ext1=2; printf("Surgiu um pedido priorit‡rio externo para %d \n", ext1)
					::ext1=3; printf("Surgiu um pedido priorit‡rio externo para %d \n", ext1)
					fi
				::floor==2 -> 
					if
					::ext1=1; printf("Surgiu um pedido priorit‡rio externo para %d \n", ext1)
					::ext1=3; printf("Surgiu um pedido priorit‡rio externo para %d \n", ext1)
					fi
				::floor==3 -> 
					if
					::ext1=1; printf("Surgiu um pedido priorit‡rio externo para %d \n", ext1)
					::ext1=2; printf("Surgiu um pedido priorit‡rio externo para %d \n", ext1)
					fi
    			fi
   			fi
		fi
	::ext1!=0 ->
		if
		::ext2 ==0 ->
			if
			::floor==1 -> 
				if
				::ext1==3 -> ext2=2; printf("Surgiu um pedido secund‡rio externo. Os pedidos externos s‹o para %d e depois para %d \n", ext1, ext2)
				::ext1==2 -> ext2=3; printf("Surgiu um pedido secund‡rio externo. Os pedidos externos s‹o para %d e depois para %d \n", ext1, ext2)
				fi
			::floor==2 -> 
				if
				::ext1==3 -> ext2=1; printf("Surgiu um pedido secund‡rio externo. Os pedidos externos s‹o para %d e depois para %d \n", ext1, ext2)
				::ext1==1 -> ext2=3; printf("Surgiu um pedido secund‡rio externo. Os pedidos externos s‹o para %d e depois para %d \n", ext1, ext2)
				fi
			::floor==3 -> 
				if
				::ext1==2 -> ext2=1; printf("Surgiu um pedido secund‡rio externo. Os pedidos externos s‹o para %d e depois para %d \n", ext1, ext2)
				::ext1==1 -> ext2=2; printf("Surgiu um pedido secund‡rio externo. Os pedidos externos s‹o para %d e depois para %d \n", ext1, ext2)
				fi
			fi
		::else -> 
		fi
	fi
}
 

 


/*Emiss‹o de pedidos internos. Esta parte Ž feita atomicamente para garantir que os pedidos internos surgem instantaneamente.*/
 
::atomic{ 
	if
	::open==true->
		if
		::int1==0 -> 
			printf("A porta est‡ aberta e pessoas est‹o a entrar \n");
			emptied=false; 
			if
			::int2!=0 && floor!=int2 -> int1=int2; int2=0; printf("Pedidos internos foram reordenados. S‹o agora para %d e depois para %d \n", int1, int2)
			::int2==0 -> 
				if
				::floor==1 -> 
					if
					::int1=2; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
					::int1=3; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
					fi
				::floor==2 -> 
					if
					::int1=1; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
					::int1=3; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
					fi
				::floor==3 -> 
					if
					::int1=1; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
					::int1=2; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
					fi
				fi
			fi
  		::int1!=0 ->
			emptied=false;
			if
			::int2 ==0 ->
				printf("A porta est‡ aberta e pessoas est‹o a entrar \n");
				if
				::floor==1 -> 
					if
					::int1==3 -> int2=2; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
					::int1==2 -> int2=3; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
					fi
    			::floor==2 -> 
					if
					::int1==3 -> int2=1; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
					::int1==1 -> int2=3; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
					fi
				::floor==3 -> 
					if
					::int1==2 -> int2=1; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
					::int1==1 -> int2=2; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
					fi
				fi
			::else -> 
			fi
		fi
	fi
}
od

}



 

 


/*elevador, que trata das partidas e das chegadas*/

active proctype Elevator(){

do

/*Processamento das chegadas. Uma chegada a um andar caracteriza-se por ser o œnico momento em que as portas est‹o fechadas.*/

::
	if
	::open==false -> 
  
		/*No instante de chegada compara-se o andar em que se est‡ com os pedidos que estavam pendentes e d‹o-se como respondidos todos aqueles que s‹o referentes ao presente andar.*/
  
		internal_emission=false; printf("O elevador est‡ no andar %d de porta fechada \n", floor);

  		/*D‹o-se como respondidos os pedidos externos pendentes. No caso de existirem, obriga-se ˆ emiss‹o de pedidos internos quando se der a partida do elevador.*/
  
		if  
		::ext2==floor -> internal_emission=true; atomic{ext2=0; printf("Pedido externo secund‡rio para %d foi satisfeito \n", floor)}
		::ext2!=floor -> 
			if
			::ext1==floor -> internal_emission=true; atomic{ext1=ext2; ext2=0;  printf("Pedido externo priorit‡rio para %d foi satifeito e pedidos externos foram reordenados. S‹o agora para %d e depois para %d \n", floor, ext1, ext2)}
			::else ->
			fi
		fi;
  
		/*D‹o-se como respondidos os pedidos internos pendentes.*/

		if
		::int2==floor -> atomic{int2=0; printf("Pedido interno secund‡rio para %d foi satisfeito \n", floor)}
		::int2!=floor -> 
			if
			::int1==floor -> atomic{int1=int2; int2=0; printf("Pedido interno priorit‡rio para %d foi satifeito e pedidos internos foram reordenados. S‹o agora para %d e depois para %d \n", floor, int1, int2)}
			::else ->
			fi
		fi;
  
		/*Se n‹o houver pedidos internos Ž porque o elevador est‡ vazio*/
  
		if   
		::atomic{int1==0 && int2==0 -> emptied=true; printf("O elevador encontra-se vazio \n")}
		::else ->
		fi;
  
		/*abre-se a porta*/

		atomic{open=true; printf("A porta abre \n")}
	fi


/*Processamento das partidas. O elevador s— vai ver os pedidos pendentes se estiver de portas abertas, caso contr‡rio est‡ a chegar. Faz-se atomicamente.*/

::
	if
	::atomic{open==true ->
		if
		::internal_emission==true ->
			if
			::int1==0 -> 
				printf("O elevador veio a este andar (%d) para responder a um pedido externo e est‡ de porta aberta, pelo que que v‹o surgir pedidos internos \n", floor);
				emptied=false;
				if
				::int2!=0 && floor!=int2 -> int1=int2; int2=0; printf("Pedidos internos foram reordenados. S‹o agora para %d e depois para %d \n", ext1, ext2)
				::int2==0 -> 
					if
					::floor==1 -> 
						if
						::int1=2; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
						::int1=3; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
						fi
					::floor==2 -> 
						if
						::int1=1; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
						::int1=3; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
						fi
					::floor==3 -> 
						if
						::int1=1; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
						::int1=2; printf("Surgiu um pedido priorit‡rio interno para %d \n", int1)
						fi
					fi
				fi
   			::int1!=0 ->
    			emptied=false;
				if
				::int2==0 ->
					printf("O elevador veio a este andar (%d) para responder a um pedido externo e est‡ de porta aberta, pelo que que v‹o surgir pedidos internos \n", floor);
					if
					::floor==1 -> 
						if
						::int1==3 -> int2=2; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
						::int1==2 -> int2=3; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
						::true ->
						fi
					::floor==2 -> 
						if
      					::int1==3 -> int2=1; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
      					::int1==1 -> int2=3; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
						::true ->
						fi
					::floor==3 -> 
						if
						::int1==2 -> int2=1; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
						::int1==1 -> int2=2; printf("Surgiu um pedido secund‡rio interno. Os pedidos internos s‹o para %d e depois para %d \n", int1, int2)
						::true ->
						fi
					fi
				::else ->
				fi
			fi;
			internal_emission=false;
		::else ->
  		fi;
  		
		if 
  
		/*Se Ž a vez de ser atendido um pedido externo ent‹o o elevador vai deslocar-se de acordo com os pedidos externos.*/

		::request==external ->
			if
			::ext1!=0 ->
				printf("Est‡ na vez de ser satifeito o pedido externo priorit‡rio para %d \n", ext1);
				if
    
				/*Verifica se h‡ pedidos para andar intermŽdio*/
    			
				::ext1!=2 && floor!=2 && (ext2==2 || int1==2 || int2==2) -> open=false; floor=2; printf("Mas antes de se ir a %d vai-se a 2. Fecha-se as portas e arranca-se \n", ext1)

    			/*Caso contr‡rio atende o pedido ext1 e passa a considerar os internos*/
    
				::else -> open=false; floor=ext1; request=internal; printf("As portas fecham, arrancamos e chegamos a %d. O pr—ximo pedido a ser respondido Ž interno \n", floor)
    	 		fi
			::else -> 
				if
				::(int1!=0)||(int2!=0) -> request=internal; open=false; printf("O pr—ximo pedido a ser respondido Ž interno \n")
				::else -> open=true
				fi
 			fi
  
		/*Se Ž a vez de ser atendido um pedido interno ent‹o o elevador vai deslocar-se de acordo com os pedidos internos.*/

		::request==internal ->
			if
			::int1!=0 ->
				printf("Est‡ na vez de ser satifeito o pedido interno priorit‡rio para %d \n", int1);
				if
    
				/*Verifica se h‡ pedidos para andar intermŽdio*/
    	
				::int1!=2 && floor!=2 && (int2==2 || ext1==2 || ext2==2) -> open=false; floor=2; printf("Mas antes de se ir a %d vai-se a 2. Fecha-se as portas e arranca-se \n", int1)

				/*Caso contr‡rio atende o pedido int1 e passa a considerar externos*/
    
				::else -> open=false; floor=int1; request=external; printf("As portas fecham, arrancamos e chegamos a %d. O pr—ximo pedido a ser respondido Ž externo \n", floor)
				fi
			::else -> 
    			if
    			:: (ext1!=0)||(ext2!=0)->request=external; open=false; printf("O pr—ximo pedido a ser respondido Ž externo \n")
	    		:: else -> open=true
	    		fi 
			fi
		fi
	}
	fi
od

}
