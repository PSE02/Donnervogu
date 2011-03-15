Ihr solltet die Textextension folgendermassen installieren können: TB>Extras>Add-Ons>Istallieren>…/test.xpi

Die Extension beinhaltet nur folgendes: In der Statusbar unten rechts steht Test Pse 1 und wenn man drauf klickt wird von einem Server ein php file geholt und dessen Inhalt in einem alert dargestellt. Das file hockt bei mir momentan noch auf einem virtuellen Apache Server. (http://localhost/getZip.php) Wenn ihr das selber testen wollt müsst ihr natürlich selber etwas in der Art einrichten.

Die Struktur jeder Extension sieht soweit ich das mittlerweile beurteilen kann folgendermassen aus:

install.rdf: Dort werden Angaben über die Extension gemacht: Autor, Version, Name etc.

chrome.manifest: Dort wird angegeben welches xul file wo, von welchem überlagert wird.

chrome>test.xul: Das ist das file welches wir einbinden. Wird die Statusbar manipuliert und die javascript Datei wird eingebunden.

chrome>test.js: Hier wird der Kern unserer Arbeit stecken. Im Moment wird dort der HttpRequest definiert.

Die restlichen Ordner und files scheinen mir bis anhin nicht so wichtig. Packt man Install.rdf, chrome.manifest, chrome ordner und den defaults ordner in ein zip und nennt es anschliessend .xpi so wird die Sache „istallierbar“. 

Hat man die Extension installiert so befindet sich bei Windows hier:
C:\Users\...\AppData\Roaming\Thunderbird\Profiles\profilename\extensions
Bei Apple oder Linux sieht der Pfad natürlich ein wenig anders aus. Damit man die Extension nicht nach jeder Modifikation neu installieren muss, kann man die Datei auch gerade dort modifizieren und anschliessend TB neu starten.
