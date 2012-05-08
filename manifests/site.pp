import "nodes"

# global defaults
# Les deux lignes suivantes servent pour le transfert de fichiers

filebucket { main: server => "creeper.emilienkenler.com" }
File { backup => main }

Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }
