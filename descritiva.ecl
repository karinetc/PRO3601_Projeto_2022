IMPORT $,STD;
base := $.File_inadimplencia.File;


// Contar quantidade de clientes:----
rec2 := RECORD
	base.id_consumidor;
	cnt := COUNT(GROUP);
END;

cross_clientes:= TABLE(base,rec2,id_consumidor);
//cross_clientes;

rec3 := RECORD
	contagem := COUNT(GROUP);
END;

quant_clientes:= TABLE(cross_clientes,rec3);
quant_clientes;

// Contar quantidade de bancos: ---
rec4 := RECORD
	base.id_inad1;
	cnt := COUNT(GROUP);
END;

cross_bancos:= TABLE(base,rec4,id_inad1);
//cross_bancos;

rec5 := RECORD
	contagem := COUNT(GROUP);
END;

quant_bancos:= TABLE(cross_bancos,rec5);
quant_bancos;

// Contar quantidade de agencias: ---
rec6 := RECORD
	base.id_inad2;
	cnt := COUNT(GROUP);
END;

cross_agencias:= TABLE(base,rec6,id_inad2);
//cross_bancos;

rec7 := RECORD
	contagem := COUNT(GROUP);
END;

quant_agencias:= TABLE(cross_agencias,rec7);
quant_agencias;

