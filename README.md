# Loxberry_DockerBuild
Docker Build Script and Installation Tools for the famous LoxBerry

# Not Supportet!
Ich habe das ganze zwar erfolgreich getestet - und ja es funktioniert, es gibt aber
 - a noch einige stellen an denen ich nicht sicher bin ob ich alles dokumentiert habe
 - b keinen Support von Loxberry selbst auf den Container
 - c keinen bzw. sehr verzögerten Support von mir auf die Anleitung
 - d auch wenn ich angefangen habe, so viel wie möglich in englisch zu dokumentieren, alle texte und hilfen innerhalb meiner Scripte sind ausschließlich auf deutsch 

# todo-listen
setup anpassen, es sollte fragen:
- (part) wo liegt docker-compose.yml
         >> nachdem noch einige manuelle Schritte sind, füge ich unser compose dort noch nicht an, das heist eigentlich brauche ich die Information gar nicht
- (done) wie soll container heisen
- (done) wo soll /opt liegen
- (part) welche ports werden wie gemappt
         >> aktuell nur port 80 und port 443,
         >> vermutlich will man das netz für den container zukünftig auf das eigentliche Host-Netz legen
- (done) Build process starten
         >> starten, weil ich leider noch nicht darum herum komme manuell interactiv etwas im container zu machen, aber sobald das image am ende abgeschlossen wird geht alles automagisch. 
- (done) aus compose-template die variablen ersetzen 

Build process erweitern:
- (done) PreInstall Script erstellen und in Image pushen
- (done) Install Script anpassen und in Image pushen

Last Steps for first Edition:
- (done) /opt automagisch wegschieben
- (done) manuelle Steps im image wenigstens automagisch starten
- (done) /opt automagisch nach ersten Containerstart zurückbringen
- (done) systemd richtig gut automagisch konfigurieren
- (open) usage / help in setup.sh aufnehmen um anzugeben was für parameter gehen würden
- (open) usability / optik der Texte an die Qualität des Install-Script vom Loxberry heranbringen
- (open) Original-Install-Script weiter optimieren um so wenig wie möglich Interaction zu haben
         >> Ziel ist keine Interaction, dann spare ich mir das zwischenzeitliche starten des Images :D

# Verwendung:
- giturl="https://github.com/markuslaube/Loxberry_DockerBuild.git"
- gitrepo="Loxberry_DockerBuild"
- git clone ${giturl}
- cd ${gitrepo}
- sudo bash setup.sh
