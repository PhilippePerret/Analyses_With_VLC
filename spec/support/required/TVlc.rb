# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Class TVlc
	----------
	Pour communiquer avec VLC au niveau des tests

=end

# 
# Pour commander VLC depuis les tests
# 
def tvlc
	@tvlc ||= TVlc.new
end

class TVlc

	# -------------------------------------------------------------------
	#
	#		METHODES PUBLIQUES DE COMMANDE
	#
	# -------------------------------------------------------------------
	
	# 
	# Pour ouvrir le film se trouvant à +path+ et le mettre en
	# lecture.
	# 
	def open_film(path)
		verbose = false
		File.exist?(path) || raise("Le film '#{path}' est introuvable…")
  	run('activate')
  	print "Ouverture du film…                    ".bleu
  	run("if fullscreen mode then\nfullscreen\nend if")
  	curitem = run("return path of current item").strip
  	if curitem != path
  		puts "L'item est différent, je dois charger le film"
  		run("open \"#{path}\"")
  		puts "'#{File.basename(path)}' ouvert dans VLC" if verbose
  		run("play \"#{path}\"")
  		puts "Film lancé" if verbose
  	end
  	print "\rSortie du mode plein écran…          ".bleu
  	run("if fullscreen mode then\nfullscreen\nend if")
  	while run("return fullscreen mode") == "true\n"
	  	run("set fullscreen mode to false")
  	end
  	print "\rPlacement de la fenêtre…           ".bleu
  	while run("return bounds of (front window)") != "1200, 23, 2000, 423\n"
  		run('set bounds of (front window) to {1200, 23, 2000, 423}')
  	end
  	print "\rArrêt de la lecture…                ".bleu
  	while run("return playing") == "true\n"
	  	run("play")
	  end
  	run("set current time to 1")
  	puts "\rVidéo prête                             ".vert
	end

	# 
	# Retourne le temps courant
	# 
	def current_time
		return run('return current_time').strip.to_i
	end

	# 
	# Définit le temps courant
	# 
	def current_time=(value)
		value = value.to_sec if value.is_a?(String)
		run("set current time to #{value}")
	end

	# -------------------------------------------------------------------
	#
	#		MÉTHODES FONCTIONNELLES
	#
	# -------------------------------------------------------------------

	def run(code)
		cmd = <<-CMD
osascript <<APSC
tell application "VLC"
  #{code}
end tell
APSC
		CMD
		# puts "--- cmd:\n#{cmd}"
		res = `#{cmd} 2>&1`
		# puts "Res de commande VLC : #{res.inspect}"
		sleep 0.5
		return res
	end

	# 
	# Pour jouer des commandes de façon temporisée, c'est-à-dire en
	# laissant le temps +laps+ entre chaque commande
	# 
	def run_temporized(cmds, laps)
		cmds.each do |cmd|
			run(cmd)
			sleep laps
		end
	end

end #/class TVlc