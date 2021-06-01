# encoding: UTF-8
# frozen_string_literal: true
=begin
	Pour choisir n'importe quel type d'élément
=end


# 
# Demande un temps à l'utilisateur
# 
def choose_a_time
	choix = Q.ask("Quel est le temps (rien pour choisir une scène) ? (horloge H:MM:SS[,FRS]")
	if choix.nil?
		sc = choose_a_scene
		if sc.nil?
			puts "Aucune scène à rejoindre (il faut les créer)".rouge
			nil
		else
			sc.time
		end
	else
		choix
	end
end

#
# Demande à l'utilisateur à choisir une scène dans la liste des
# scènes déjà enregistrées
# 
def choose_a_scene(options = nil)
	return nil if film.elements(:scene).count == 0
	numero = 0
	Q.select("Quelle scène ?") do |q|
		q.choices film.elements(:scene).collect { |sc| {name: "#{numero += 1} #{sc.resume_tty}", value: sc} }
		q.per_page 20
	end
end