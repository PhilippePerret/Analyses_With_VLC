# encoding: UTF-8
# frozen_string_literal: true
=begin
	Module qui permet de simuler l'utilisation du Terminal
=end

# 
# Joue le code 'code' dans la fenêtre Terminal courante
# 
def run(code)
	TTerminal.type(code)
	sleep 1.5
end

# 
# Retourne les +nombre_dernieres_lignes+ dernières lignes en
# console.
# 
def console(nombre_dernieres_lignes = 4)
	contenu = TTerminal.current.content(nombre_dernieres_lignes)
	contenu = contenu.join("\n") if contenu.is_a?(Array)
	return contenu
end


# -------------------------------------------------------------------
#
#		Class TTerminal
# 	---------------
# 	Pour gérer le Terminal au cours des tests
#
# -------------------------------------------------------------------
class TTerminal
class << self
	attr_reader :window_id

	# -------------------------------------------------------------------
	#
	#		MÉTHODES PUBLIQUES D'ACTION
	#
	# -------------------------------------------------------------------
	# 
	# Une fois que le programme est lancé (TTerminal.launch), on peut
	# utiliser cette méthode pour entrer en interaction avec l'app
	# 
	def type(what)
		run("do script \"#{what}\" in #{current.tab}")
	end

	# -------------------------------------------------------------------
	#
	#		MÉTHODES PUBLIQUES DE TEST
	#
	# -------------------------------------------------------------------
	
	# 
	# Fenêtre courante
	# 
	def current
		@current
	end

	# -------------------------------------------------------------------
	#
	#		MÉTHODES SYSTÉMIQUES
	#
	# -------------------------------------------------------------------

	# 
	# Script appelé pour lancer le script en ligne de commande
	# 
	# Ensuite, on utilise TTerminal.type("...") pour taper des 
	# chose au clavier.
	# 
	# +params+
	# 
	# 	:film_path		Le chemin d'accès au film, if any
	# 
	def launch(params = nil)

		# 
		# Si un Terminal est ouvert, il faut la fermer
		# 
		current.close if current

		if params && params[:film_path]
			AWV.update_hotdata(last_film_path: params[:film_path])
		end

		@current = new(params)
		@current.launch

	end

	# 
	# Jouer le code +code+ dans l'application Terminal par
	# osascript
	# 
	def run(code)
		cmd = <<-CMD
osascript <<APSC
tell application "Terminal"
	#{code}
end tell
APSC
		CMD
		res = `#{cmd} 2>&1`
		return (res||'').strip
	end
end #/<< self
end	

# 
# Lance l'application Analyse With VLC
# 
# Par défaut, on met le film './asset/film/Neverland_extrait.mkv' en
# film.
# 
def launch_app(params = nil)
	if params.nil? || not(params.key?(:film_path))
		params ||= {}
		params.merge!(film_path:'/Users/philippeperret/Programmation/Analyses_With_VLC/spec/assets/film/Neverland_extrait.mkv')
	end
	TTerminal.launch(params)
end
