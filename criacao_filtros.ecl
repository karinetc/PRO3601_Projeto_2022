IMPORT $;

base := $.File_inadimplencia.File;

//Contagem negativa no que for 50
filtro_50 :=base.comando  = '50';
recset50 := base(filtro_50);

rec50 := RECORD
    base.id_consumidor;
    base.id_inad1;
    base.id_inad2;
    base.tipo_baixa;
    base.contagem;
    base.Data_mov;
    base.Comando;
		base.data_recebimento;
		contagem_sinal := base.contagem* (-1);
END;

base50 :=TABLE(recset50, rec50);
base50;

//Contagem positiva no que for 10
filtro_10 :=base.comando  = '10';
recset10 := base(filtro_10);

rec10 := RECORD
    base.id_consumidor;
    base.id_inad1;
    base.id_inad2;
    base.tipo_baixa;
    base.contagem;
    base.Data_mov;
    base.Comando;
		base.data_recebimento;
		contagem_sinal := base.contagem;
END;

base10 := TABLE(recset10, rec10);
base10;

//Juntando os dois: --------------
completo := MERGE(base50,base10,SORTED(id_consumidor, data_recebimento));
completo;

