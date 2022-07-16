//######################################################################
IMPORT $;
// Visualizações: ---------------

IMPORT $.^.Visualizer;
TabelaConc := $.file_2021.File;


// Inadimplentes
OUTPUT(SORT(TABLE(TabelaConc, {data_base, UNSIGNED INTEGER4 Inadimplentes_Mes := SUM(GROUP, inadimplente)}, data_base, FEW), data_base), NAMED('Pessoas_Inadimplentes_Viz'));
Visualizer.MultiD.column('myChart', /*datasource*/, 'Pessoas_Inadimplentes_Viz', /*mappings*/, /*filteredBy*/, /*dermatologyProperties*/ );
