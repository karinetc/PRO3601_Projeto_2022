//######################################################################
IMPORT $;
// Visualizações: ---------------

IMPORT $.^.Visualizer;
TabelaConc := $.file_2021.File;


// Excluidas
OUTPUT(TABLE(TabelaConc, {data_base, UNSIGNED INTEGER4 Excluidas_Mes := SUM(GROUP, quant_excluidas_30_dias)}, data_base, FEW), NAMED('Excluidas_Viz'));
Visualizer.MultiD.column('myChart', /*datasource*/, 'Excluidas_Viz', /*mappings*/, /*filteredBy*/, /*dermatologyProperties*/ );
