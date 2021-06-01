# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'info', pour les informations du film

	La commande permet de les lire et de les définir (quand le 
	fichier n'existe pas ou qu'une information important manque.)
	
=end
require_folder(File.join(__dir__,'info'))
class Commande
class << self

	def info(params = nil)
		film.display_infos
	end

end #/<< self
end