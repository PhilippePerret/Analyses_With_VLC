# Manuel développeur

## Introduction / présentation

Ce fichier présente l’aide pour le développement de l’application **AWV** (**Analyse With VLC**) qui est un assistant à la collecte et l’analyse d’informations sur les films, en ligne de commande couplée avec l’application VLC.

### Ouverture de ce manuel

**En mode lecture**

~~~
help -dev
~~~

**En mode écriture**

~~~
help -dev -w/--write
~~~

### Ouverture du manuel de l'utilisateur

**En mode lecture	**

~~~
help
~~~

**En mode écriture**

~~~
help -w/--write
~~~



---

## Synopsis général de l'application

* On lance l’application à l’aide de l’alias `awv` (défini dans le bash profil),

  => Une invite s’affiche, attendant la première commande

* on tape la première commande,

* elle est passée dans `AWV.parse_command(buffer)`

  => retourne le premier mot (`word1`) qui est la commande véritable, et les paramètres (cf. le fichier `lib/required/then/AWV.rb` pour le détail)

* si c’est une commande « normale », son fichier se trouve dans le dossier `lib/commandes/` et il est chargé et joué.

---

## Options

Elles sont définies dans la constantes `OPTIONS_SHORT_TO_LONG` dans le fichier `lib/required/first/constants.rb`.

## Commandes alternatives
Une « commande alternative » est un autre mot qu’on peut utiliser pour invoquer une commande. Par exemple, pour afficher le fichier d’aide, on joue la commande officielle `help`. Mais on peut utiliser aussi la *commande alternative* `aide`.

Ces commandes alternatives sont définies dans `ALT_COMMAND_TO_REAL` dans le fichier `lib/required/first/constants.rb`.

## Commandes

### Création d’une nouvelle commande

* lui faire un dossier (ou un simple fichier si elle est simple) dans le dossier `lib/commandes/`,
* faire la méthode de base `Commande::<nom de la commande` qui sera appelée par la commande.

Si la commande est définie dans un dossier, seuls les modules à la racine de ce dossier seront automatiquement chargés. Cela permet d’utiliser des sous-modules qui ne seront chargés qu’au besoin.

Par exemple :

* Soit la commande **`joue`**.

* Définie dans le dossier `lib/commandes/joue/Commande.rb` qui contiendra :

  ~~~ruby
  class Commande
  	def self.joue
  		... code ...
    end
  end
  ~~~

* Soit un sous-module **`encore`** défini dans `lib/commandes/joue/modules/encore.rb` définissant :

  ~~~ruby
  class Commande
    def self.joue_encore
      ... code ici ...
    end
  end
  ~~~

  

* Il ne sera pas joué au chargement de la commande mais pourra l’appeler par :

  ~~~ruby
  def self.joue
    require_relative 'modules/encore'
    joue_encore
  end
  ~~~

  

