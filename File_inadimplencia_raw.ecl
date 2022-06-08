EXPORT File_inadimplencia_raw := MODULE
	EXPORT Layout:=	RECORD
    STRING Origem;
    STRING Data_recebimento;
    STRING Id_consumidor;
    STRING Tipo_pessoa;
    STRING Id_inad1;
    STRING Id_inad2;
    STRING Tipo_baixa;
    STRING Contagem;
    STRING Data_mov;
    STRING Comando;
		END;
		EXPORT File:=DATASET('~projeto::tema1::pro3601::base_inadimplencia_ccf.csv',Layout,CSV(heading(1)));
END;