# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Extension de la class Film pour gérer les informations du film

=end
class Film

	# 
	# Affiche les données du film
	# ---------------------------
	# Et demande les informations manquantes
	# 
	def display_infos
		missing_values = []

		# 
		# Affichage des informations
		# --------------------------
		# 
		puts "\nINFORMATIONS DU FILM"
		puts "--------------------"
		infos.each do |key, value|
			if value.nil?
				missing_values << key 
				value = "manquante".rouge
			end
			puts "#{(key.to_s+' ').ljust(20,'.')} #{value.to_s}"
		end
		puts "--------------------\n\n"

		if missing_values.count > 0
			ask_for_missing_infos_values(missing_values)
		end
	end

	# 
	# Enregistre les informations sur le film
	# Cf. la méthode `infos' pour voir les clés
	# 
	def save_infos
		File.open(infos_path,'wb'){|f|f.write(YAML.dump(infos))}
	end

	# 
	# Méthode qui permet de demande à l'utilisateur les données
	# du film courant
	# 
	def ask_for_missing_infos_values(missing_keys)
		missing_keys.each do |key|
			@infos.merge!(key => Q.ask("#{key.to_s.capitalize} du film :"))
		end
		save_infos
	end
end