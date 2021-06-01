# encoding: UTF-8
# frozen_string_literal: true
=begin
	Commande 'try'
	Pour essayer du code ou le jouer sur le film courant
	Définir simplement le code du fichier 'code_to_run.rb'
=end
class Commande
class << self
	def try(params = nil)
		begin
			load File.join(__dir__,'code_to_run.rb')
		rescue Exception => e
			puts "Une erreur s'est produite en jouant 'code_to_run.rb' : #{e.message}".rouge
			puts e.backtrace.join("\n").rouge
		end
	end
end #/<< self
end #/Commande