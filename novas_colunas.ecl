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

// Rollup_CSZ := ROLLUP (base_trans,  LEFT.id_consumidor=RIGHT.id_consumidor,
										// RollCSV(LEFT,RIGHT)) ;


// OUTPUT( SORT(Rollup_CSZ,data_recebimento)) ;

// Fazendo o rollup por mês ####################################################################

// JANEIRO 2020: ---------------------------------

base_janeiro_2020:= base_trans(data_base = '202001');

janeiro_2020 :=SORT ( ROLLUP (base_janeiro_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
janeiro_2020;

rep_join_janeiro := JOIN(RepTable2(data_base = '202001'),janeiro_2020,
									LEFT.data_base=RIGHT.data_base AND
									LEFT.id_consumidor=RIGHT.id_consumidor);


// FEVEREIRO 2020: ----------------------------------------
base_fevereiro_2020:= base_trans(data_base = '202002');

base2_fevereiro_2020 := SORT(base_fevereiro_2020 + janeiro_2020, id_consumidor, data_base);
//OUTPUT ( SORT (base2_fevereiro_2020, id_consumidor));

fevereiro_2020 :=SORT ( ROLLUP (base2_fevereiro_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_fevereiro := JOIN(RepTable2(data_base = '202002'),fevereiro_2020,
									LEFT.data_base=RIGHT.data_base AND
									LEFT.id_consumidor=RIGHT.id_consumidor);


// MARCO 2020: ----------------------------------------
base_marco_2020:= base_trans(data_base = '202003');

base2_marco_2020 := SORT(base_marco_2020 + fevereiro_2020, id_consumidor, data_base);

marco_2020 :=SORT ( ROLLUP (base2_marco_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_marco := JOIN(RepTable2(data_base = '202003'),marco_2020,
									LEFT.data_base=RIGHT.data_base AND
									LEFT.id_consumidor=RIGHT.id_consumidor);
									
									

// ABRIL 2020: ----------------------------------------
base_abril_2020:= base_trans(data_base = '202004');

base2_abril_2020 := SORT(base_abril_2020 + marco_2020, id_consumidor, data_base);

abril_2020 :=SORT ( ROLLUP (base2_abril_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_abril := JOIN(RepTable2(data_base = '202004'),abril_2020,
									LEFT.data_base=RIGHT.data_base AND
									LEFT.id_consumidor=RIGHT.id_consumidor);
									
									
// MAIO 2020: ----------------------------------------
base_maio_2020:= base_trans(data_base = '202005');

base2_maio_2020 := SORT(base_maio_2020 + abril_2020, id_consumidor, data_base);

maio_2020 :=SORT ( ROLLUP (base2_maio_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_maio := JOIN(RepTable2(data_base = '202005'),maio_2020,
									LEFT.data_base=RIGHT.data_base AND
									LEFT.id_consumidor=RIGHT.id_consumidor);
									
									
									
// JUNHO 2020: ----------------------------------------
base_junho_2020:= base_trans(data_base = '202006');

base2_junho_2020 := SORT(base_junho_2020 + maio_2020, id_consumidor, data_base);

junho_2020 :=SORT ( ROLLUP (base2_junho_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_junho := JOIN(RepTable2(data_base = '202006'),junho_2020,
									LEFT.data_base=RIGHT.data_base AND
									LEFT.id_consumidor=RIGHT.id_consumidor);
									
									
									
// JULHO 2020: ----------------------------------------

base_julho_2020:= base_trans(data_base = '202007'); 

base2_julho_2020:= SORT(base_julho_2020 + junho_2020, id_consumidor, data_base); 

julho_2020 :=SORT ( ROLLUP (base2_julho_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_julho_2020 := JOIN(RepTable2(data_base = '202007'),julho_2020,
								LEFT.data_base=RIGHT.data_base AND
								LEFT.id_consumidor=RIGHT.id_consumidor); 


// AGOSTO 2020: ----------------------------------------

base_agosto_2020:= base_trans(data_base = '202008'); 

base2_agosto_2020:= SORT(base_agosto_2020 + julho_2020, id_consumidor, data_base); 

agosto_2020 :=SORT ( ROLLUP (base2_agosto_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_agosto_2020 := JOIN(RepTable2(data_base = '202008'),agosto_2020,
								LEFT.data_base=RIGHT.data_base AND
								LEFT.id_consumidor=RIGHT.id_consumidor); 
								
								
								
// SETEMBRO 2020: ----------------------------------------

base_setembro_2020:= base_trans(data_base = '202009'); 

base2_setembro_2020:= SORT(base_setembro_2020 + agosto_2020, id_consumidor, data_base); 

setembro_2020 :=SORT ( ROLLUP (base2_setembro_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);

rep_join_setembro_2020 := JOIN(RepTable2(data_base = '202009'),setembro_2020,
								LEFT.data_base=RIGHT.data_base AND
								LEFT.id_consumidor=RIGHT.id_consumidor); 
								
								


 // OUTUBRO 2020: ----------------------------------------
 
  base_outubro_2020:= base_trans(data_base = '202010'); 
 
  base2_outubro_2020:= SORT(base_outubro_2020 + setembro_2020, id_consumidor, data_base); 
 
  outubro_2020 :=SORT ( ROLLUP (base2_outubro_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_outubro_2020 := JOIN(RepTable2(data_base = '202010'),outubro_2020,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // NOVEMBRO 2020: ----------------------------------------
 
  base_novembro_2020:= base_trans(data_base = '202011'); 
 
  base2_novembro_2020:= SORT(base_novembro_2020 + outubro_2020, id_consumidor, data_base); 
 
  novembro_2020 :=SORT ( ROLLUP (base2_novembro_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_novembro_2020 := JOIN(RepTable2(data_base = '202011'),novembro_2020,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // DEZEMBRO 2020: ----------------------------------------
 
  base_dezembro_2020:= base_trans(data_base = '202012'); 
 
  base2_dezembro_2020:= SORT(base_dezembro_2020 + novembro_2020, id_consumidor, data_base); 
 
  dezembro_2020 :=SORT ( ROLLUP (base2_dezembro_2020,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_dezembro_2020 := JOIN(RepTable2(data_base = '202012'),dezembro_2020,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // JANEIRO 2021: ----------------------------------------
 
  base_janeiro_2021:= base_trans(data_base = '202101'); 
 
  base2_janeiro_2021:= SORT(base_janeiro_2021 + dezembro_2020, id_consumidor, data_base); 
 
  janeiro_2021 :=SORT ( ROLLUP (base2_janeiro_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_janeiro_2021 := JOIN(RepTable2(data_base = '202101'),janeiro_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // FEVEREIRO 2021: ----------------------------------------
 
  base_fevereiro_2021:= base_trans(data_base = '202102'); 
 
  base2_fevereiro_2021:= SORT(base_fevereiro_2021 + janeiro_2021, id_consumidor, data_base); 
 
  fevereiro_2021 :=SORT ( ROLLUP (base2_fevereiro_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_fevereiro_2021 := JOIN(RepTable2(data_base = '202102'),fevereiro_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // MARCO 2021: ----------------------------------------
 
  base_marco_2021:= base_trans(data_base = '202103'); 
 
  base2_marco_2021:= SORT(base_marco_2021 + fevereiro_2021, id_consumidor, data_base); 
 
  marco_2021 :=SORT ( ROLLUP (base2_marco_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_marco_2021 := JOIN(RepTable2(data_base = '202103'),marco_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // ABRIL 2021: ----------------------------------------
 
  base_abril_2021:= base_trans(data_base = '202104'); 
 
  base2_abril_2021:= SORT(base_abril_2021 + marco_2021, id_consumidor, data_base); 
 
  abril_2021 :=SORT ( ROLLUP (base2_abril_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_abril_2021 := JOIN(RepTable2(data_base = '202104'),abril_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // MAIO 2021: ----------------------------------------
 
  base_maio_2021:= base_trans(data_base = '202105'); 
 
  base2_maio_2021:= SORT(base_maio_2021 + abril_2021, id_consumidor, data_base); 
 
  maio_2021 :=SORT ( ROLLUP (base2_maio_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_maio_2021 := JOIN(RepTable2(data_base = '202105'),maio_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // JUNHO 2021: ----------------------------------------
 
  base_junho_2021:= base_trans(data_base = '202106'); 
 
  base2_junho_2021:= SORT(base_junho_2021 + maio_2021, id_consumidor, data_base); 
 
  junho_2021 :=SORT ( ROLLUP (base2_junho_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_junho_2021 := JOIN(RepTable2(data_base = '202106'),junho_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // JULHO 2021: ----------------------------------------
 
  base_julho_2021:= base_trans(data_base = '202107'); 
 
  base2_julho_2021:= SORT(base_julho_2021 + junho_2021, id_consumidor, data_base); 
 
  julho_2021 :=SORT ( ROLLUP (base2_julho_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_julho_2021 := JOIN(RepTable2(data_base = '202107'),julho_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // AGOSTO 2021: ----------------------------------------
 
  base_agosto_2021:= base_trans(data_base = '202108'); 
 
  base2_agosto_2021:= SORT(base_agosto_2021 + julho_2021, id_consumidor, data_base); 
 
  agosto_2021 :=SORT ( ROLLUP (base2_agosto_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_agosto_2021 := JOIN(RepTable2(data_base = '202108'),agosto_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // SETEMBRO 2021: ----------------------------------------
 
  base_setembro_2021:= base_trans(data_base = '202109'); 
 
  base2_setembro_2021:= SORT(base_setembro_2021 + agosto_2021, id_consumidor, data_base); 
 
  setembro_2021 :=SORT ( ROLLUP (base2_setembro_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_setembro_2021 := JOIN(RepTable2(data_base = '202109'),setembro_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // OUTUBRO 2021: ----------------------------------------
 
  base_outubro_2021:= base_trans(data_base = '202110'); 
 
  base2_outubro_2021:= SORT(base_outubro_2021 + setembro_2021, id_consumidor, data_base); 
 
  outubro_2021 :=SORT ( ROLLUP (base2_outubro_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_outubro_2021 := JOIN(RepTable2(data_base = '202110'),outubro_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // NOVEMBRO 2021: ----------------------------------------
 
  base_novembro_2021:= base_trans(data_base = '202111'); 
 
  base2_novembro_2021:= SORT(base_novembro_2021 + outubro_2021, id_consumidor, data_base); 
 
  novembro_2021 :=SORT ( ROLLUP (base2_novembro_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_novembro_2021 := JOIN(RepTable2(data_base = '202111'),novembro_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // DEZEMBRO 2021: ----------------------------------------
 
  base_dezembro_2021:= base_trans(data_base = '202112'); 
 
  base2_dezembro_2021:= SORT(base_dezembro_2021 + novembro_2021, id_consumidor, data_base); 
 
  dezembro_2021 :=SORT ( ROLLUP (base2_dezembro_2021,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_dezembro_2021 := JOIN(RepTable2(data_base = '202112'),dezembro_2021,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // JANEIRO 2022: ----------------------------------------
 
  base_janeiro_2022:= base_trans(data_base = '202201'); 
 
  base2_janeiro_2022:= SORT(base_janeiro_2022 + dezembro_2021, id_consumidor, data_base); 
 
  janeiro_2022 :=SORT ( ROLLUP (base2_janeiro_2022,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_janeiro_2022 := JOIN(RepTable2(data_base = '202201'),janeiro_2022,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // FEVEREIRO 2022: ----------------------------------------
 
  base_fevereiro_2022:= base_trans(data_base = '202202'); 
 
  base2_fevereiro_2022:= SORT(base_fevereiro_2022 + janeiro_2022, id_consumidor, data_base); 
 
  fevereiro_2022 :=SORT ( ROLLUP (base2_fevereiro_2022,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_fevereiro_2022 := JOIN(RepTable2(data_base = '202202'),fevereiro_2022,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // MARCO 2022: ----------------------------------------
 
  base_marco_2022:= base_trans(data_base = '202203'); 
 
  base2_marco_2022:= SORT(base_marco_2022 + fevereiro_2022, id_consumidor, data_base); 
 
  marco_2022 :=SORT ( ROLLUP (base2_marco_2022,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_marco_2022 := JOIN(RepTable2(data_base = '202203'),marco_2022,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // ABRIL 2022: ----------------------------------------
 
  base_abril_2022:= base_trans(data_base = '202204'); 
 
  base2_abril_2022:= SORT(base_abril_2022 + marco_2022, id_consumidor, data_base); 
 
  abril_2022 :=SORT ( ROLLUP (base2_abril_2022,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_abril_2022 := JOIN(RepTable2(data_base = '202204'),abril_2022,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





 // MAIO 2022: ----------------------------------------
 
  base_maio_2022:= base_trans(data_base = '202205'); 
 
  base2_maio_2022:= SORT(base_maio_2022 + abril_2022, id_consumidor, data_base); 
 
  maio_2022 :=SORT ( ROLLUP (base2_maio_2022,  LEFT.id_consumidor=RIGHT.id_consumidor, RollCSV(LEFT,RIGHT)), id_consumidor);
  
 rep_join_maio_2022 := JOIN(RepTable2(data_base = '202205'),maio_2022,
    									LEFT.data_base=RIGHT.data_base AND
    									LEFT.id_consumidor=RIGHT.id_consumidor);  





							
base_parcial := rep_join_janeiro + rep_join_fevereiro + rep_join_marco + rep_join_abril + rep_join_maio + rep_join_junho + rep_join_julho_2020  + rep_join_agosto_2020  + rep_join_setembro_2020 + rep_join_outubro_2020 + rep_join_novembro_2020 + rep_join_dezembro_2020 + rep_join_janeiro_2021 + rep_join_fevereiro_2021 + rep_join_marco_2021 + rep_join_abril_2021 + rep_join_maio_2021 + rep_join_junho_2021  + rep_join_julho_2021 + rep_join_agosto_2021 + rep_join_setembro_2021 + rep_join_outubro_2021 + rep_join_novembro_2021 + rep_join_dezembro_2021 + rep_join_janeiro_2022 + rep_join_fevereiro_2022 + rep_join_marco_2022 + rep_join_abril_2022 + rep_join_maio_2022; 
output(sort(base_parcial, id_consumidor, data_base));
//count(base_parcial);


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
OUTPUT(SORT( base_final, id_consumidor, data_base));
//OUTPUT( SORT( base_final, id_consumidor, data_base), , 'pro3601::quod::ktc::base' );

