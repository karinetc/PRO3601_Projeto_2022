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
                                                                 



Layout_soma := RECORD
  base_nova.id_consumidor;
	base_nova.data_base;
	INTEGER3 total_inadimplencias := base_nova.contagem_sinal ;
END;

base_trans := SORT (
											TABLE(base_nova, Layout_soma
											), id_consumidor, data_base
											);
//base_trans;

myrec1 := RECORD
  base_trans.id_consumidor;
	base_trans.data_base;

END;

ds1 := SORT (TABLE(base_trans, myrec1), id_consumidor, data_base);
                                                                                     
//ds1;
                                                                                                                      
                                                                                                                      
myrec2 := RECORD
base_trans.data_base;
END;

ds2 := DEDUP(  SORT (
											TABLE(base_trans, myrec2
											), data_base
											) );
                                                                                                                      
//ds2;     

mysrt := DEDUP(GROUP(SORT(ds1,id_consumidor, data_base),id_consumidor),id_consumidor, data_base);
//mysrt;                                                                            
                                                                                                                      
myrec1 MyTransf(myrec1 le, myrec2 ri) := TRANSFORM
SELF.data_base := ri.data_base;
SELF := Le;
END;


                                                                                                       
myjoin := DEDUP(SORT(JOIN(mysrt,ds2,LEFT.data_base<>RIGHT.data_base,MyTransf(LEFT, RIGHT), ALL),id_consumidor, data_base)
,id_consumidor, data_base);

//myjoin;

// rec2 := RECORD
  // data_base:= myjoin.data_base;
	// cnt := COUNT(GROUP);
// END;

// crosstab := SORT (TABLE(myjoin,rec2,myjoin.data_base), data_base);
// crosstab;


myjoin2 := DEDUP(SORT(JOIN(myjoin,ds2,LEFT.data_base<>RIGHT.data_base,MyTransf(LEFT, RIGHT), ALL),id_consumidor, data_base)
,id_consumidor, data_base);

//myjoin2;

// rec2 := RECORD
  // data_base:= myjoin2.data_base;
	// cnt := COUNT(GROUP);
// END;

// crosstab := SORT (TABLE(myjoin2,rec2,myjoin2.data_base), data_base);
// crosstab;



// Join : ------------------------------------------------------------------------------------------
Layout_novo_campo := RECORD
  myjoin2.id_consumidor;
	myjoin2.data_base;
	INTEGER3 total_inadimplencias := 0 ;
	//INTEGER3 total_inadimplencias_2 := 0;
END;


myjoin3 := DEDUP(  SORT (
											TABLE(myjoin2, Layout_novo_campo
											), id_consumidor, data_base
											) );
                                                                                                                      
//myjoin3;  


Layout_novo_campo MyTransf3( Layout_novo_campo Le, Layout_soma Ri) := TRANSFORM

SELF.total_inadimplencias := IF ( Le.data_base > Ri.data_base OR Le.data_base = Ri.data_base, 
																		SUM(base_trans(id_consumidor = Le.id_consumidor AND data_base <= Le.data_base), total_inadimplencias),
																		0);
SELF := Le;
END;


                                                                                                       
join_final := DEDUP(SORT(JOIN(myjoin3, base_trans, LEFT.id_consumidor=right.id_consumidor,MyTransf3(LEFT, RIGHT)), id_consumidor, data_base), id_consumidor, data_base);

join_final;

//OUTPUT( SORT( join_final, id_consumidor, data_base), , 'pro3601::quod::ktc::adicao_linhas', OVERWRITE );

// #####################################################################
// #####################################################################


MyReportFormat2 := RECORD
 base_nova.id_consumidor;
 base_nova.data_base;
 quant_incluidas_30_dias := SUM(GROUP, base_nova.contagem_inclusao);
 quant_excluidas_30_dias := SUM(GROUP, base_nova.contagem_exclusao);
 inadi_abertas := 0;
 END;
RepTable2 := SORT (TABLE(base_nova,MyReportFormat2,id_consumidor,data_base), data_base, id_consumidor);
OUTPUT(RepTable2);

// /// versão final: ------

Formato_completo := RECORD
 base_nova.id_consumidor;
 base_nova.data_base;
 INTEGER3 quant_incluidas_30_dias := 0;
 INTEGER3 quant_excluidas_30_dias := 0;
 INTEGER3 total_inadimplencias := 0
 END;

Formato_completo Agrupamento(Layout_novo_campo le) := TRANSFORM

SELF.quant_incluidas_30_dias := IF ( EXISTS (RepTable2( id_consumidor = le.id_consumidor AND data_base = le.data_base))
								 , RepTable2( id_consumidor = le.id_consumidor AND data_base = le.data_base)[1].quant_incluidas_30_dias , 0);

SELF.quant_excluidas_30_dias := IF ( EXISTS (RepTable2( id_consumidor = le.id_consumidor AND data_base = le.data_base))
								 , RepTable2( id_consumidor = le.id_consumidor AND data_base = le.data_base)[1].quant_excluidas_30_dias , 0);

// SELF.total_inadimplencias := IF ( EXISTS (RepTable2( id_consumidor = le.id_consumidor AND data_base = le.data_base))
								 // , RepTable2( id_consumidor = le.id_consumidor AND data_base = le.data_base)[1].total_inadimplencias , 0);


SELF := Le;
END;


                                                                                                       
base_parcial := DEDUP(SORT(PROJECT(join_final, Agrupamento(LEFT)), id_consumidor, data_base), id_consumidor, data_base);

base_parcial;

// Indicador se a pessoa está ou não inadimplente naquele mês : ############################################
rec_final := RECORD
  base_parcial.id_consumidor;
	base_parcial.data_base;
  base_parcial.quant_incluidas_30_dias;
	base_parcial.quant_excluidas_30_dias;
	base_parcial.total_inadimplencias;
	inadimplente := 0
END;

formato_parcial := TABLE(base_parcial, rec_final);

rec_final Classificacao( rec_final Le) := TRANSFORM
SELF.inadimplente:= IF(Le.total_inadimplencias > 0, 1, 0);
SELF := Le;
END;



base_final := PROJECT (formato_parcial, Classificacao(LEFT)); 
base_final;


OUTPUT( SORT( base_final, id_consumidor, data_base), , '~pro3601::quod::base' , OVERWRITE)