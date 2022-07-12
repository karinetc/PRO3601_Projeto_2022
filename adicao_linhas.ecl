// Iniciando
base := $.File_inadimplencia.File;

rec := RECORD
  base.id_consumidor;
  base.id_inad1;
  base.id_inad2;
  base.tipo_baixa;
  base.contagem;
  base.Data_mov;
  base.Comando;
base.data_recebimento;
STRING6 data_base :='';
INTEGER3 contagem_sinal :=0 ;
INTEGER3 contagem_inclusao :=0 ;
INTEGER3 contagem_exclusao :=0 ;
END;

novo_formato := TABLE(base, rec);

rec Adicao( rec Le) := TRANSFORM
SELF.contagem_sinal:= IF(Le.comando='50', - Le.Contagem, Le.contagem);
SELF.contagem_inclusao:= IF(Le.comando='50', 0, Le.contagem);
SELF.contagem_exclusao:= IF(Le.comando='10', 0, Le.contagem);
SELF.data_base := Le.data_recebimento[1..6];
SELF := Le;
END;



base_nova := PROJECT (novo_formato, Adicao(LEFT));                  
                                                                 
//base_nova;

//  Fazendo as contas por id_consumidor e data_base: --------

//TotInad := SUM(base_nova,contagem_inclusao);


MyReportFormat2 := RECORD
 base_nova.id_consumidor;
 base_nova.data_base;
 quant_incluidas_30_dias := SUM(GROUP, base_nova.contagem_inclusao);
 quant_excluidas_30_dias := SUM(GROUP, base_nova.contagem_exclusao);
 //inadi_abertas := 0;
 END;
RepTable2 := SORT (TABLE(base_nova,MyReportFormat2,id_consumidor,data_base), data_base, id_consumidor);
OUTPUT(RepTable2);

// Rollup sum: somando total de inadimplencias que a pessoa tem:-------

Layout_soma := RECORD
  base_nova.id_consumidor;
  //base_nova.id_inad1;
  //base_nova.id_inad2;
  //base_nova.tipo_baixa;
  //base_nova.contagem;
  //base_nova.Data_mov;
  //base_nova.Comando;
	//base_nova.data_recebimento;
	base_nova.data_base;
	//base_nova.contagem_sinal ;
	//base_nova.contagem_inclusao ;
	//base_nova.contagem_exclusao  ;
	INTEGER3 total_inadimplencias := base_nova.contagem_sinal ;
END;

base_trans := SORT (
											TABLE(base_nova, Layout_soma
											), id_consumidor, data_base
											);
base_trans;



Layout_soma RollCSV(Layout_soma L, Layout_soma R) := TRANSFORM
	SELF.total_inadimplencias := IF (L.id_consumidor=R.id_consumidor, 
																	L.total_inadimplencias + R.total_inadimplencias, 
																	R.total_inadimplencias);
	SELF := R;
END;

// Criar o dataset de datas: ---------------------

Layout_parcial := RECORD
  base_trans.id_consumidor;
	base_trans.data_base;
END;

base_parcial := SORT (
											TABLE(base_trans, Layout_parcial
											), id_consumidor, data_base
											);
base_parcial;

Layout_datas := RECORD
	base_trans.data_base;
END;

base_datas := DEDUP(  SORT (
											TABLE(base_trans, Layout_datas
											), data_base
											) );
base_datas;


Layout_parcial MyTransf(Layout_parcial le, Layout_datas ri) := TRANSFORM
SELF.data_base := ri.data_base;
SELF := Le;
END;
                                                                                              
myjoin := DEDUP(SORT(JOIN(base_parcial,base_datas,LEFT.data_base<>RIGHT.data_base,MyTransf(LEFT, RIGHT), ALL), id_consumidor, data_base));

myjoin;

// Join : ------------------------------------------------------------------------------------------
Layout_novo_campo := RECORD
  base_nova.id_consumidor;
	base_nova.data_base;
	//INTEGER3 total_inadimplencias := base_nova.contagem_sinal ;
	INTEGER3 total_inadimplencias_2 := 0;
END;


Layout_novo_campo MyTransf3(Layout_parcial le) := TRANSFORM

SELF.total_inadimplencias_2 := IF ( EXISTS (base_trans( id_consumidor = le.id_consumidor AND data_base = le.data_base))
								 , base_trans( id_consumidor = le.id_consumidor AND data_base = le.data_base)[1].total_inadimplencias , 0);
SELF := Le;
END;


                                                                                                       
join_final := DEDUP(SORT(PROJECT(myjoin, MyTransf3(LEFT)), id_consumidor, data_base), id_consumidor, data_base);

join_final;