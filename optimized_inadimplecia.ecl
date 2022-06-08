IMPORT $,STD;

base := $.File_inadimplencia_raw.File;

//profileResults := STD.DataPatterns.Profile(base);
bestrecord     := STD.DataPatterns.BestRecordStructure(base);


//OUTPUT(profileResults, ALL, NAMED('profileResults'));
OUTPUT(bestrecord, ALL, NAMED('BestRecord'));