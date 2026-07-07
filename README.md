# UrbanStyle Müügianalüüs ja RFM-Kliendisegmentatsioon

## Äriprobleem
UrbanStyle juhtkond vajas sisendit eeloleva aasta turunduseelarve planeerimiseks ja lojaalsusprogrammi muutmiseks, et lõpetada ebaefektiivsed pime-kampaaniad.

## Peamised järeldused ("So what?")
* Meie analüüs tuvastas, et kõigest 15% UrbanStyle'i püsiklientidest genereerib üle poole ettevõtte 1,09 miljoni eurosest kogukäibest.
* Selle teadmise põhjalt loodud mudel võimaldab juhtkonnal lõpetada kulukad pime-kampaaniad ning suunata turunduseelarve otse kõige tulusamale ja kasumlikumale kliendigrupile.
* Tulemusena hoiab ettevõte kokku turunduskulusid, kasvatab püsiklientide lojaalsust ja suurendab reaalset äritulu.

## Lähenemine ja kasutatud tööriistad
* **Andmebaas & valideerimine:** SQL (Supabase) ristikontrolliks ja päringuteks.
* **Andmete puhastamine:** Python (`pandas`) dublikaatide eemaldamiseks ja andmete korrastamiseks.
* **Analüüs & visuaal:** Power BI kliendimudeli loomiseks ja tulemuste kuvamiseks.

## Projektivisuaal
!['UrbanStyle Dashboard'](KPI_Dashboard.jpg)

## Kuidas käivitada
Käivita järgmised käsud oma arvuti käsureal (Terminal, Git Bash või Command Prompt):

1. Klooni repositoorium oma arvutisse:
   `git clone https://github.com/KairiMerila/urbanstyle-rfm-analysis.git`
2. Liigu projekti kausta:
   `cd urbanstyle-rfm-analysis`
3. Paigalda vajalikud Pythoni teegid:
   `pip install -r requirements.txt`
4. Jooksuta skript:
   `python main.py`  
   
## AI Kasutamine
Kasutasin Claude'i SQL päringu veaparandusel ja README teksti viimistlemiseks. Analüütiline loogika ja ärijäreldused on minu omad.
