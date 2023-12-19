# Loxberry_Installer
Docker Build Script and Installation Tools for the famous LoxBerry

# nicht funktional!
Ich habe den Loxberry zwar schon im Container laufen, muss die Schritte aber noch dokumentieren / Ins Script bringen

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
