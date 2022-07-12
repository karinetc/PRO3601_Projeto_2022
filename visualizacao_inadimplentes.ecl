//######################################################################
IMPORT $;
// Visualizações: ---------------

IMPORT $.^.Visualizer;
TabelaConc := $.file_2021.File;

// Inadimplentes
OUTPUT(TABLE(TabelaConc, {data_base, UNSIGNED INTEGER4 Inadimplentes_Mes := SUM(GROUP, inadimplente)}, data_base, FEW), NAMED('Inadimplentes_Viz'));
Visualizer.MultiD.column('myChart', /*datasource*/, 'inadimplentes_Viz', /*mappings*/, /*filteredBy*/, /*dermatologyProperties*/ );
