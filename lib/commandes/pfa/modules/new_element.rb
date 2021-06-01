# encoding: UTF-8
# frozen_string_literal: true
=begin
	Module pour créer un nouvel élément
=end
class PFA

	def self.proceed_define_element(params)
		puts "params: #{params}"
		if params[:options][:pfa]
			index_pfa = params[:options][:pfa].to_i
			self.current = get(index_pfa) || return
			film.update_hotdata(index_current_pfa: index_pfa)
		end
		if PFA.count == 0
			return erreur("Il faut instancier un premier PFA ! (jouer '#{INVITE}pfa init')")
		elsif PFA.count > 1 && film.hotdata[:index_current_pfa].nil?
			self.current = ask_for_pfa("Dans quel paradigme doit-on placer l'élément ?", multi = false) || return
		elsif self.current.nil?
			self.current = film.hotdata[:index_current_pfa] || all.first.index
		end
		clear
		puts "Définir un nœud du PFA pour le #{current.name}. (relancer la commande avec '--pfa=<index>' pour changer)".jaune
		current.define_new_element(params) || return
	end
	

	def define_new_element(params)
		if params[2] && not(PFA::DATA_NOEUDS.key?(params[2].to_sym))
			erreur("Le type de nœud PFA #{params[2].to_sym.inspect} est inconnu…")
			params[2] = nil
		end
		etype = params[2] || choose_type_element || return
		etype = etype.to_sym

		# 
		# Ce nœud est-il déjà défini pour le PFA courant ?
		# Si c'est le cas, il faut demander confirmation qu'on va le
		# modifier
		# 
		data_element = nil
		if not noeud(etype).nil?
			if not Q.yes?("Le nœud “#{etype.inspect}” est déjà défini, pour le PFA “#{name}”. Voulez-vous vraiment le modifier ?".bleu)
				return
			end
			data_element = noeud(etype)
		else
			data_element = {
				type: etype,
				start_time: nil,
				end_time: 	nil,
				description: nil,
			}
		end
		
		# 
		# On règle le temps de départ de ce nœud
		# 
		data_element[:start_time] = VLC.current_time

		# 
		# Définir le temps de fin
		# 
		if Q.yes?("Veux-tu définir la fin du nœud ?".bleu)
			data_element[:end_time] = VLC.choose_time_after(data_element[:start_time]) || return
		end

		# 
		# Description de l'élément
		# 
		if data_element[:description]
			puts "La description actuelle (par défaut) vaut :\n#{"«"*30}\n#{data_element[:description]}\n#{'»'*30}"
		end
		desc = Q.multiline("Description de l'élément “#{DATA_NOEUDS[data_element[:type]][:long_name]}” : ".bleu) do |q|
			q.default data_element[:description].split("\n")
			q.help "Ctrl D pour terminer"
		end || return
		data_element[:description] = desc.join("\n")

		# 
		# On peut créer ou actualiser l'élément
		# 
		@data[:noeuds] ||= {}
		@data[:noeuds].merge!(etype => data_element)
		save
		puts "Nœud “#{etype}“ du PFA “#{name}” enregistré avec succès".vert
	end


	def choose_type_element
		Q.select("Quel élément doit être défini ?") do |q|
			q.choices types_element_for_tty_prompt 
			q.per_page types_element_for_tty_prompt.count
		end
	end

	def types_element_for_tty_prompt
		@types_element_for_tty_prompt ||= begin
			PFA::DATA_NOEUDS.collect do |etype, ehash|
				{name: "#{ehash[:long_name]||ehash[:hname]} (#{"#{etype.to_s.jaune}"})", value: etype}
			end << {name: "Renoncer", value: nil}
		end
	end

end #/class PFA
