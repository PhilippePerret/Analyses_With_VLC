# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'film'

=end

class Commande

	def self._film(params)
		case params[1]
		when 'infos', 'info'
			`open -a "#{Config[:yaml_editor]}" "#{film.infos_path}"`
		
		when 'edit'

			# Édition de tout le film, on ouvre son dossier dans
			# Sublime Text ou autre application d'édition (config)

			`open -a "#{Config[:app_editing]}" "#{film.main_folder}"`

		end
	end

end #/class Commande