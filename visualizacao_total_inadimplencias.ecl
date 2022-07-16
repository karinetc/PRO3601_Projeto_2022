//######################################################################
IMPORT $;
// Visualizações: ---------------

IMPORT $.^.Visualizer;
TabelaConc := $.file_2021.File;

// Total
OUTPUT(SORT(TABLE(TabelaConc, {data_base, UNSIGNED INTEGER4 Total_Mes := SUM(GROUP, total_inadimplencias)}, data_base, FEW), data_base), NAMED('Total_Viz'));
Visualizer.MultiD.column('myChart', /*datasource*/, 'Total_Viz', /*mappings*/, /*filteredBy*/, /*dermatologyProperties*/ );
