# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	class Commande

=end

class Commande
class << self

	# 
	# Requiert le module ou le dossier de la commande +word+
	# 
	# @return TRUE en cas de succès, NIL en cas d'échec
	# 
	# Noter que pour les commandes définies dans un dossier, seuls les
	# modules à la racine du dossier sont chargés. Cela permet de mettre
	# des sous-modules dans des dossiers.
	# 
	# Noter que certaines commandes, comme 'note[s]', 'info[s]' etc.
	# n'ont pas à proprement parler de dossier commande, elles agissent
	# sur des classes constantes, comme 'Note', 'Info', 'Scene'.
	# 
	# 
	def require_commande(word)
		case word.downcase
		when 'note', 'notes' 			then 	return '_note' 	# cf ci-dessous
		when 'scene', 'scenes' 		then return '_scene'	# cf ci-dessous
		when 'info', 'infos'			then 	return '_info'	# cf ci-dessous
		when 'marque', 'marques' 	then return '_marque'	# cf ci-dessous
		when 'film' then word = '_film'
		end
		command_name, command_path = real_command_from(word) || return
		if File.directory?(command_path)
			require_folder(command_path, deep = false)
		else
			require command_path
		end

		return command_name
	end

	# +word+ est le string passé à l'invite (premier mot)
	def real_command_from(word)
		word = word.downcase
		if File.exist?(File.join(COMMANDS_FOLDER,word)) # un dossier
			[word, File.join(COMMANDS_FOLDER,word)]
		elsif File.exist?(File.join(COMMANDS_FOLDER,"#{word}.rb"))
			[word, File.join(COMMANDS_FOLDER,"#{word}.rb")]
		elsif word.end_with?('s')
			real_command_from(word[0..-2])
		else
			puts "La commande '#{word}' est introuvable… Jouer 'help' pour obtenir de l'aide".rouge
			nil
		end
	end

	def _note(params)
		Note.send((params[1]||:sans_action).to_sym)
	end
	def _info(params)
		Info.send((params[1]||:sans_action).to_sym)
	end
	def _scene(params)
		Scene.send((params[1]||:sans_action).to_sym)
	end
	def _marque(params)
		Marque.send((params[1]||:sans_action).to_sym)
	end

	def exec_lettre_commande(lettre_commande, params)
		current_time = VLC.current_time - 1

		hcurtime = current_time.to_h

		case lettre_commande
		when 'x'
			return 'export'
		when 'm'
			# Nouvelle marque
			Marque.create(params) # attention : méthode propre
		when 's'
			# Nouvelle scène
			resume = ask_for("Résumé de la nouvelle scène à #{hcurtime} (vide pour renoncer)") || return
			Scene.create(resume.strip, current_time)
		when 'n'
			# Nouvelle note
			note = ask_for("Contenu de la nouvelle note à #{hcurtime} (vide pour renoncer)") || return
			Note.create(note, current_time)
		when 'i'
			# Nouvelle information
			info = ask_for("Information à enregistrer au temps #{hcurtime} (vide pour renoncer) : ") || return
			Info.create(info, current_time)
		when 'q'
			puts "À bientôt !".bleu
			exit 0
		else
			puts "Je ne sais pas traiter la lettre-commande '#{lettre_commande}'…"
		end

		return nil # pour ne pas poursuivre
	end

end #/<< self
end #/class Commande