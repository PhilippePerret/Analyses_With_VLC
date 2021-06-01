# TODO Liste

* Pouvoir placer les fenêtres de façon automatique en lançant l'application (osascript qui commande sa propre fenêtre).

* Mémoriser le dernier film

* Pouvoir recharger le dernier film

* Généraliser le fait que la première phrase est le résumé et ensuite c'est la description. Utiliser 'RC' tout seul pour par les retours chariots. Mais prévenir lorsque l'on utilise RC comme identifiant de personnage. Pouvoir changer la marque de retour de chario dans les configurations.

* Une fenêtre indépendante qui suit la vidéo en affichant les éléments qu'on trouve. Revoir comment on fait pour placer des éléments à des endroits précis de l'écran. Appeler cet outil la timeline.

* Pouvoir 'git'er les données du film (en privé). C'est-à-dire, concrètement :
	- init git dans le dossier de l'analyse de film
	- le pusher sur github pour initier le dépôt
	- actualiser régulièrement 
	NOTE : on n'aura plus besoin des backups, donc.

* Mettre en place l'enregistrement de la dernière commande.

* Mettre en place la possibilité de rejouer la dernière commande avec le trait plat

* À la création d'un élément de film, il faudrait lui donner un identifiant universel (c'est la seule manière de pouvoir y faire référence ensuite — sauf qu'on pourrait aussi y faire référence avec son type et son horloge — à condition que l'horloge et que le type ne changent jamais, ce qui est trop risqué => UUID)

* Pour les PFA, produire plutôt une image SVG (pour le moment, c'est une image JPEG qui est produite).

* Rationnaliser le traitement des commandes (il y en a un peu trop dans tous les sens, en ce moment)