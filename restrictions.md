Meine Testergebnisse hier zusammengefasst. Mit dem Hinweis, das ich den Loxberry 3.x noch nirgends wo anders im Einsatz hatte und mit Debian12 natürlich auch da schon "Beta" bezogen auf den Loxberry bin

- [X] - https aktivieren und nutzen
- [X] - Paswörter / SuperPIN über Config setzen
- [X] - MQTT ausschalten (auf externen legen, was anderes macht aus meiner Sicht im Container auch keinen Sinn.
- [X] - Sprache und Namen vom Loxberry anpassen
- [X] - Dateimanager
- [X] - Updates --> Ich habs aber "noch" nicht genutz. Frage ist vermutlich auch, was wir hier bedenken müssen bzgl. externes /opt und korrekt version im Container ...
- [X] - Terminal
- [ ] - Netzwerk-Config über web: LoxBerry w   arnt, da kein Raspi, sollte ja bitte auch nicht gehen :D 
- [ ] - Backup "Es funktioniert nur auf Raspberrys", keine Warnung, naja wer Docker einsetzt sollte wissen wir er die Daten sichert :D
- [X] - Mini-Server verbinden
- [ ] - Mini-Server per Scan finden, wie ich schon irgendwo schrieb ... vermutlich sollte der LoxBerry eher anders ins Netz kommen als ich das tue
- [X] - Plugins aus github installieren
- [ ] - Allerdings bei TExt2SIP hab ich aktuell einen fehler der auf irgendwas zwischen Loxberry3, Debian12 hinweist:
        14:12:20.709 CRITICAL: Error installing  libssl1.0-dev sox task-spooler  - Error 100
        14:12:20.709 WARNING: (Some) Packages could not be installed.
- [ ] - Any Plugin, das nervt mich persönlich :-/
        14:16:53.128 CRITICAL: The Plugin Interface is not supported by this LoxBerry Version. I cannot proceed with the installation.
        Vermutlich eine Inkopatibilität zwischen LoxBerry3 und den Plugin?
- [ ] - InterCom22Lox -> Funktionier allerdings hatte ich Fehler wenn ich den Loxberry per https ausfrufe ... ich glaub da kommt er wegen den Ports durcheinander ...
        Korrektur: Livestream geht, Bilder werden aber entweder nicht aufgezeichnet,
        PHP Fatal error:  Uncaught Error: Call to undefined function imagecreatefromjpeg() in /opt/loxberry/webfrontend/html/plugins/intercom22lox/getpicture.php:11
- [ ] - Generelles:
        ==> /var/log/apache2/error.log <==
        pgrep: pattern that searches for process name longer than 15 characters will result in zero matches
        Try `pgrep -f' option to match against the complete command line.
