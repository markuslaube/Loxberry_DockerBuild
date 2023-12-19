# Loxberry_Installer
Docker Build Script and Installation Tools for the famous LoxBerry

# Not Supportet!
Ich habe das ganze zwar erfolgreich getestet - und ja es funktioniert, es gibt aber
 - a noch einige stellen an denen ich nicht sicher bin ob ich alles dokumentiert habe
 - b keinen Support von Loxberry selbst auf den Container
 - c keinen bzw. sehr verzögerten Support von mir auf die Anleitung
 - d auch wenn ich angefangen habe, so viel wie möglich in englisch zu dokumentieren, alle texte und hilfen innerhalb meiner Scripte sind ausschließlich auf deutsch 

# todo-listen
setup anpassen, es sollte fragen:
- (done) wo liegt docker-compose.yml
- (done) wie soll container heisen
- (part) wo soll /opt liegen
- (part) welche ports werden wie gemappt
- (done) Build process starten 
- (done) aus compose-template die variablen ersetzen und an docker-compose angängen

Build process erweitern:
- (done) PreInstall Script erstellen und in Image pushen
- (done) Install Script anpassen und in Image pushen

Last Steps for first Edition:
- /opt automagisch wegschieben
- manuelle Steps im image wenigstens automagisch starten
- /opt automagisch nach ersten Containerstart zurückbringen

# Verwendung:
- giturl="https://github.com/markuslaube/Loxberry_DockerBuild.git"
- gitrepo="Loxberry_DockerBuild"
- git clone ${giturl}
- cd ${gitrepo}
- sudo bash setup.sh
