# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'scene'

=end

class Commande
class << self

	# 
	# Reçoit et traite la commande principale 'scene'
	# 
	def scene(params = nil)
		if params[:as_sentence]
			intitule = params[:as_sentence]
			Scene.create(film, intitule)
		else
			# 
			# Aucune scène spécifiée, on propose la liste des scènes pour
			# en choisir une
			# 
			VLC.goto(choose_a_scene.time)
		end
	end

end # /<< self

end #/COmmande