bit res_in=0; /*res_in Ž 1 se o respons‡vel est‡ no quarto, 0 caso contr‡rio*/
byte na=0; /*na Ž o nœmero de alunos no quarto*/
bit busca=0; /*busca Ž 1 se est‡ a decorrer uma busca, 0 caso contr‡rio*/

active [6] proctype A(){
bit a_in=0;

do
:: atomic{res_in==0&&a_in==0 -> na++;a_in=1;printf("Alunos: %d\n",na)}
:: atomic{a_in==1 -> na--;a_in=0;printf("Alunos: %d\n",na)}
od

}

active proctype R(){

do
:: atomic{res_in==0 && na>3 -> res_in=1;printf("Ajuntamento\n")}
:: atomic{res_in==0 && na==0 -> res_in=1;busca=1;printf("Busca\n")}
:: atomic{res_in==1 && na==0 -> res_in=0;busca=0}
 
od

}
