# encoding: UTF-8
# frozen_string_literal: true
=begin
	Module pour créer une nouvelle intrigue
=end
class AWV::Intrigue
class << self
	# 
	# Instanciation (création) d'une nouvelle intrigue
	# 
	def init
		int_id 		= self.count + 1 # note : instancie forcément ::all
		int_titre				= ask_for_titre("Titre de l'intrigue") || return
		int_type 				= ask_for_type || return
		int_description = ask_for_description("Description de l'intrigue") || return
		data_intrigue = {
			id: int_id,
			titre: int_titre,
			type: int_type,
			description: int_description
		}
		@all << new(data_intrigue)
		save
		puts "= Intrigue créée avec succès. =".vert
	end


	def ask_for_type
		Q.select("Type de l'intrigue") do |q|
			q.choices TYPES.values << {name: "Renoncer"}
			q.per_page TYPES.keys.count + 1
		end
	end
end #/<< self
end #/class AWV::Intrigue
