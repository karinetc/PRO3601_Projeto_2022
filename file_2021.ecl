
EXPORT file_2021 := MODULE
	EXPORT Layout:=	RECORD
		STRING6 data_base;
		INTEGER3 quant_incluidas_30_dias;
		INTEGER3 quant_excluidas_30_dias;
		INTEGER3 total_inadimplencias;
		INTEGER3 inadimplente;
		
		END;
		EXPORT File:=DATASET('~pro3601::quod::acumulado_2021',Layout,Flat);
END;