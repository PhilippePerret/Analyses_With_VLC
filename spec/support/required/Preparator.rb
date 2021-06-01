# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Le Préparateur des tests

=end
class Preparator
class << self

	# 
	# {Hash}
	# 
	# Initie les tests avec les paramètres +params+
	# Ces paramètres sont retournés avec les valeurs à l'intérieur.
	# Par exemple, si params[:film] est à :default, au retour de params
	# params[:film] contiendra l'instance TFilm du film.
	# 
	# +params+
	# 
	# 	:app 			Si FALSE, on ne lance pas l'application. Donc elle est
	# 						toujours lancée par défaut.
	# 
	# 	:film			Si :default, le préparator met le film test en place
	# 						Contient l'instance TFilm au retour.
	# 
	def init_with(params)
		
		if params[:film]
			film_name = params[:film]
			film_name = default_film_name if film_name == :default
			tfilm = TFilm.new(film_name)
			tfilm.prepare
			params.merge!(film: tfilm)
		end

		unless params[:app] === false
			launch_app
		end

		return params
	end




#
# Nom du film par défaut
# 
def default_film_name
	@default_film_name ||= 'default_film.mkv'
end

end #/<< self
end #/class Preparator