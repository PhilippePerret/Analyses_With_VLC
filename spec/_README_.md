# Manuel pour les tests

## Lancer l'applilcation

~~~rpsec

it "un texte" do
	launch_app
end
~~~

> Par défaut, c'est le film dans './spec/support/assets/film' qui est ouvert.

### Pour lancer l'application sur un film particulier

~~~rspec
it "un test" do
	launch_app(film_path: '/le/path/to/film.mkv')
end
~~~

### Pour lancer l'application sans film

~~~rspec
it "un test" do
	launch_app(film_path: nil)
end
~~~

## Ouvrir un film dans VLC

~~~ruby

before(:all) do
	vlc.open_file(path/to/film)
end

~~~

## Tester le retour console

~~~ruby

expect(console(4)).to include("ce texte")
# Test si les 4 dernières lignes de retour de l'application contien-
# nent le texte

~~~

## VLC

### Obtenir le temps courant

~~~ruby

temps_courant = vlc.current_time

~~~

### Définir le temps courant

~~~ruby

vlc.current_time = temps_courant

~~~