# encoding: UTF-8
# frozen_string_literal: true
=begin

	Module pour instancier un nouveau PFA

=end
class PFA
class << self

	def proceed_init
		pfa_name = ask_for_pfa_name || return
		pfa_description = ask_for_pfa_description(pfa_name) || return
		pfa = PFA.new(index: PFA.count + 1, name: pfa_name, description: pfa_description)
		pfa.save
		if File.exist?(pfa.path)
			PFA.current = pfa
			puts "Le paradigme #{pfa_name} a été créé avec succès et défini en paradigme courant.".vert
			puts "Utilise la commande '#{INVITE}pfa ne[ <type>]' pour ajouter de nouveaux\nnœuds en regardant la vidéo.".bleu
		end
	end

	def ask_for_pfa_name
		default_name = 
		case PFA.count
		when 0 then 'PFA principal'
		when 1 then 'PFA secondaire'
		else nil
		end
		Q.ask("Nom (humain) du paradigme ", default: default_name)
	end

	def ask_for_pfa_description(pfa_name)
		Q.multiline("Description succinct du paradigme “#{pfa_name}” :")
	end

end #/<< self
end #/ class PFA
