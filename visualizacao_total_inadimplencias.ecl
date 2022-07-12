//######################################################################
IMPORT $;
// Visualizações: ---------------

IMPORT $.^.Visualizer;
TabelaConc := $.file_2021.File;

// Total
OUTPUT(TABLE(TabelaConc, {data_base, UNSIGNED INTEGER4 Total_Mes := SUM(GROUP, total_inadimplencias)}, data_base, FEW), NAMED('Total_Viz'));
Visualizer.MultiD.column('myChart', /*datasource*/, 'Total_Viz', /*mappings*/, /*filteredBy*/, /*dermatologyProperties*/ );
