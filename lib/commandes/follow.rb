# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'follow'
	Permet de suivre le film en affichant les éléments collectés et
	les scènes.

=end
class Commande
class << self
	
	def follow(params)
		clear
		Screen.init

		start_time = VLC.current_time

		current_resume = "[Résumé de la scène courante]"
		next_scene = nil
		scenes = film.elements(:scene)
		while next_scene = scenes.shift
			break if next_scene.time > start_time
			current_resume = next_scene.real_resume
		end


		all_elements = []
		Film::TYPES_ELEMENTS.each do |etype, edata|
			next if etype == 'scene'
			all_elements += film.elements(etype)
		end
		# puts "Nombre d'éléments : #{all_elements.count}"

		# 
		# ATTENTION : les éléments sont placés dans l'ordre inverse
		# pour pouvoir utiliser 'pop' plutôt que 'shift'
		# 
		all_elements = all_elements.sort_by{|e| - e.time}
		while next_element = all_elements.pop
			break if next_element.time > start_time
			# puts "#{next_element.time.to_h} #{next_element.real_resume}"
		end
		# puts "Nombre d'éléments conservés : #{all_elements.count}"

		write_element_a_venir(next_element)

		begin
			
			ctime 		= start_time
			# end_time 	= start_time + 60
			
			while true # ctime < end_time
				ctime = VLC.current_time
				Screen. update(ctime)
				if ctime >= next_scene.time
					current_resume = next_scene.real_resume
					next_scene = scenes.shift
				end
				while next_element && ctime >= next_element.time
					Screen << next_element
					next_element = all_elements.pop
				end
				write_element_a_venir(next_element)

				write_resume("#{ctime.to_h} #{current_resume}")
				sleep 1
			end

		rescue Exception => e
			puts e.message.rouge
			puts e.backtrace.join("\n").rouge
			puts "(j'attends une minute)"
			sleep 60
			exit 1
		ensure
			VLC.stop
			clear
		end
	end

def write_resume(resume)
	Screen.place(resume, 1, 1, full = true)
end
def write_element_a_venir(element)
	return
	Screen.place(element.ref, 3, 40)
end

end #/<< self
end #/class Commande

class Screen
class << self
	attr_reader :cycle
	def init
		@cycle = []
	end
	def <<(element)
		@cycle << element
	end

	def place(str, x, y, fullline = false)
		# printf "\337\33[#{x};#{y}H#{str}\338" # remet le curseur en position
		str = str.ljust(80) if fullline
		printf "\33[#{x};#{y}H#{str}\n"
	end

	# 
	# Actualise tout l'affichage pour le temps +attime+
	# 
	def update(attime)
		# puts "Nombre d'éléments dans le cycle : #{cycle.count}"
		@cycle = cycle.collect.with_index do |element, idx|
			top = 4 + idx
			# place("element.time = #{element.time} | attime = #{attime}", 2, 0)
			if element.time < attime - 40
				# Cet élément doit être supprimé
				place(" ", top, 0, full = true)
				place(" ", top + 10, 0, full = true)
				nil
			else
				colonne = element.time - attime
				place("  #{element.tag}", top, colonne - 2)
				place("#{element.tag} #{element.time.to_h} #{element.real_resume}", top + 10, 0, full = true)
				element
			end
		end.compact
	end

end #/<< self
end #/class Screen
