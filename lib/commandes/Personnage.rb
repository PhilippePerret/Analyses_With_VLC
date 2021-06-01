# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'personnage'

=end

class Commande
class << self

	# 
	# Reçoit et traite la commande principale 'personnage'
	# 
	def personnage(params)
		case params[1]
		when 'edit'
			Personnage.edit
		when NilClass, 'list'
			Personnage.show_list
		else
			puts "Je ne sais pas encore montrer les informations d'un personnage".jaune
		end
	end

end # /<< self

end #/Commande