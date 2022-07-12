
EXPORT File_base_comp := MODULE
	EXPORT Layout:=	RECORD
    STRING32 Id_consumidor;
		STRING6 data_base;
		INTEGER3 quant_incluidas_30_dias;
		INTEGER3 quant_excluidas_30_dias;
		INTEGER3 total_inadimplencias;
		INTEGER1 inadimplente;
		
		END;
		EXPORT File:=DATASET('~thor::pro3601::quod::ktc::base',Layout,Flat);
END;