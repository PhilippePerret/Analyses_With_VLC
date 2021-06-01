# encoding: UTF-8
# frozen_string_literal: true
=begin
	Module qui permet de simuler l'utilisation du Terminal
=end

# -------------------------------------------------------------------
#
#		Class TTerminal
# 	---------------
# 	Pour gérer le Terminal au cours des tests
#
# -------------------------------------------------------------------
class TTerminal
	attr_reader :params
	attr_reader :window_id

	def initialize(params)
		@params = params
	end

	def launch
		res = run("do script \"#{MAIN_SCRIPT_PATH}\"")
		@window_id = res.strip.match(/window id ([0-9]+)$/).to_a[1].to_i
		# puts "ID Fenêtre : #{@window_id}"
		set_bounds_of_window
		sleep 0.3
		wait_while_busy
	end

	# 
	# Régler la taille de la fenêtre
	# 
	def set_bounds_of_window
		run("set bounds of window id #{window_id} to {0, 0, 1000, 300}")
	end

	def close
		# puts "Je ferme le terminal courant d'id #{window_id}"
		sleep 0.5
		# On sort de la commande awv
		run("do script \"exit\" in tab 1 of window id #{window_id}")
		sleep 0.2
		# On sert du Terminal
		run("do script \"exit\" in tab 1 of window id #{window_id}")
		sleep 0.3
		# On ferme la fenêtre
		run("close window id #{window_id}")
		@window_id = nil
	end

	# 
	# Méthode pour attendre que le processus soit achevé
	def wait_while_busy
		begin
			is_busy = run("return busy of #{tab}") == 'true'
			break if not is_busy
			last_line = content(1)
			# puts "last_line.strip = #{last_line.strip.inspect}"
			is_ready = last_line&.strip == AWV_INVITE
			break if is_ready
			sleep 0.5
		end while true
	end

	# 
	# Retourne les +nombre_last+ dernière lignes du terminal de
	# l'application
	# 
	def content(nombre_last = 4)
		if nombre_last.nil? || nombre_last == 1
			visible_lines.last
		elsif nombre_last < 4
			visible_lines[-nombre_last..-1]
		else
			get_history_content(-nombre_last, -1)			
		end
	end

	def visible_lines
		run("return contents of #{tab}").split("\n")
	end

	def get_history_content(from_back_line, to_back_line)
		cmd = <<-CODE
osascript <<TEXT
tell application "Terminal"
	tell #{tab}
		return history
	end tell
end tell
TEXT
CODE
		# puts "CODE =\n#{cmd}"
		res = `#{cmd}`
		res = res.split("\n")
		from_back_line = 0 if - from_back_line > res.count
		res[from_back_line..to_back_line].join("\n")
	end

	def tab
		@tag ||= "tab 1 of window id #{window_id}"
	end


	def run(code)
		self.class.run(code)
	end

end	#/class TTerminal
