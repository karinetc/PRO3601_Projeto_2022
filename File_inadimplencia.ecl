EXPORT File_inadimplencia := MODULE
	EXPORT Layout:=	RECORD
    STRING32 origem;
    STRING10 Data_recebimento;
    STRING32 id_consumidor;
    STRING1 tipo_pessoa;
    STRING32 id_inad1;
    STRING32 id_inad2;
    STRING2 tipo_baixa;
    INTEGER3 contagem;
    STRING8 Data_mov;
    STRING2 Comando;
		END;
		EXPORT File:=DATASET('~ktc::base_inadimplencia_ccf.csv',Layout,CSV(heading(1)));
END;