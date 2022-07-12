
IMPORT $;

base := $.File_base_comp.File;
base;

// Soma dos atributos, em 2021 -----------------
filtro_data :=base.data_base >= '202101' AND base.data_base <= '202112';

recset := base(filtro_data);
recset;

Concatenacao := RECORD
 recset.data_base;
 quant_incluidas_30_dias := SUM(GROUP, recset.quant_incluidas_30_dias);
 quant_excluidas_30_dias := SUM(GROUP, recset.quant_excluidas_30_dias);
 total_inadimplencias := SUM(GROUP, recset.total_inadimplencias);
 inadimplente := SUM(GROUP, recset.inadimplente);
 END;

TabelaConc := SORT (TABLE(recset, Concatenacao, data_base), data_base);
//OUTPUT(TabelaConc);

OUTPUT( TabelaConc , ,'~pro3601::quod::acumulado_2021' );