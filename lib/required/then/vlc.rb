# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	class VLC
	----------

=end

# 
# Pour exécuter dans l'application VLC le code +code+
# 
def vlc(code)
	cmd = <<-CMD
osascript <<TEXT
tell application "VLC"
	#{code}
end tell
TEXT
	CMD

	`#{cmd} 2>&1`
end

class VLC
class << self
	
	# 
	# Le temps de la vidéo (en secondes) lorsque la dernière commande a
	# été jouée
	# 
	attr_accessor :command_time

	def activate
		`osascript -e 'tell application "VLC" to activate'`
	end
	def togglePlay; 
		vlc("activate\nplay") 
		tell_me_to_activate
	end
	def play; 	vlc(PLAY_CODE) 	end
	def stop; 	vlc(PAUSE_CODE)	end
	alias :pause :stop

	def goto(time, options = nil)
		time = 1 if time == 0
		`osascript <<TEXT
tell application "VLC"
	set current time to #{time}
end
		TEXT`
	end


	def current_time
		vlc('return current time').to_i
	end

	def current_time=(value)
		value = 1 if value == 0
		vlc("set current time to #{value}")
	end
	alias :set_current_time :current_time=

	CHOIX_TEMPS = {
		"Oui" => true,
		"Non, poursuivre plus loin" => :goon,
		"Non, reprendre au commencement" => :redo,
		"Renoncer" => nil
	}

	# 
	# Méthode permettant de choisir un temps après le temps +ref_time+
	# de façon interactive, et avec la possibilité de le réajuster.
	# 
	def choose_time_after(ref_time)
		puts "Presse la touche SPACE pour démarrer la vidéo, stoppe-la au temps voulu avec RETURN.".bleu
		Q.keypress("¨Presse la touche espace quand tu seras prêt.", keys: [:space])
		after_time = nil
		until after_time
			VLC.play
			Q.keypress("Presse RETURN quand c'est bon…", keys: [:return])
			VLC.pause
			case Q.select("Ce temps est-il bon ?", CHOIX_TEMPS, per_page: CHOIX_TEMPS.count)
			when true
				return VLC.current_time
			when :goon
				# On poursuit simplement
			when :redo
				VLC.current_time = ref_time - 2
			when NilClass
				return
			end
		end

	end

	# 
	# Ouvre le film de path +film_path+
	# 
	def open_film(film_path)
		print "* J'ouvre le film, merci de patienter…".bleu
		vlc(<<-CODE)
activate
fullscreen
set fullscreen mode to false
open "#{film_path}"
if not playing then
	play
end if
set bounds of front window to {0, 23, 960, 489}
play -- pour arrêter
		CODE
		puts "\r= Film ouvert, tu peux commencer la collecte.".vert
	end
	
end #<< self

PAUSE_CODE = <<-CMD
if playing is true then
	play
end if
CMD

PLAY_CODE = <<-CMD
if playing is false then
	play
end if
CMD

end #/class VLC