EXPORT File_inadimplencia := MODULE
	EXPORT Layout:=	RECORD
    STRING32 origem;
    STRING8 Data_recebimento;
    STRING32 id_consumidor;
    STRING1 tipo_pessoa;
    STRING32 id_inad1;
    STRING32 id_inad2;
    UNSIGNED1 tipo_baixa;
    UNSIGNED1 contagem;
    STRING8 Data_mov;
    REAL4 Comando;
		END;
		EXPORT File:=DATASET('~projeto::tema1::pro3601::base_inadimplencia_ccf.csv',Layout,CSV(heading(1)));
END;