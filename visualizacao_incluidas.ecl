//######################################################################
IMPORT $;
// Visualizações: ---------------

IMPORT $.^.Visualizer;
TabelaConc := $.file_2021.File;


// Incluidas
OUTPUT(TABLE(TabelaConc, {data_base, UNSIGNED INTEGER4 Incluidas_Mes := SUM(GROUP, quant_incluidas_30_dias)}, data_base, FEW), NAMED('Incluidas_Viz'));
Visualizer.MultiD.column('myChart', /*datasource*/, 'Incluidas_Viz', /*mappings*/, /*filteredBy*/, /*dermatologyProperties*/ );
