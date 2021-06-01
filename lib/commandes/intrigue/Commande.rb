# encoding: UTF-8
# frozen_string_literal: true
=begin
	Commande 'intrigue',
	pour la gestion des intrigues
=end
class Commande

	# 
	# Méthode appelée par la commande 'intrigue[s]' pour la
	# gestion des intrigues du film.
	# 
	def self.intrigue(params)
		
		if params[1] && not(AWV::Intrigue.respond_to?(params[1].to_sym))
			# La sous-commande est l'action à jouer. Ça doit être une 
			# méthode de la classe AWC::Intrigue. Si cette méthode n'existe
			# pas encore, c'est qu'il faut charger un module. On s'assure 
			# que ce module existe bien.
			if File.exist?(File.join(__dir__,'modules',"#{params[1]}.rb"))
				params[1] = params[1].to_sym
			else
				erreur("La sous-commande :#{params[1]} est inconnue.")
				params[1] = nil
			end
		end
	
		action = params[1] || Q.select("Que veux-tu faire ?".bleu, AWV::Intrigue::ACTIONS_OF_COMMAND) || return
		if not AWV::Intrigue.respond_to?(action)
			require_relative "modules/#{action}.rb"
		end
		AWV::Intrigue.send(action)
	end

end #/Commande
