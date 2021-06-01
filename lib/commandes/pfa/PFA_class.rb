# encoding: UTF-8
# frozen_string_literal: true
=begin
	Class PFA
	----------
	Pour la gestion des paradigmes de Field
=end
class PFA

# -------------------------------------------------------------------
#
#		CLASSE
#
# -------------------------------------------------------------------
class << self

	# Le paradigme de Field courant (instance PFA)
	attr_accessor :current

	def current ; @current end
	def current=(pfa)
		pfa = get(pfa) if pfa.is_a?(Integer)
		@current = pfa
		film.update_hotdata(index_current_pfa: pfa.index)
	end

	# 
	# Retourne l'instance du paradigme de field d'index +index+
	# 
	def get(index)
		@pfas ||= {}
		@pfas[index] ||= begin
			ppath = File.join(film.pfa_folder,"pfa#{index}.yaml")
			if File.exist?(ppath)
				new(YAML.load_file(ppath))
			else
				puts "Le paradigme d'index #{index} n'existe pas…".rouge
				nil
			end
		end
	end

	# 
	# Permet de définir un élément du paradigme de Field
	# 
	# Note : l'élément est toujours créé dans le paradigme courant
	# 
	def define_element(params)
		require_relative 'modules/new_element'
		proceed_define_element(params)
	end

	# 
	# Instancier un nouveau PFA
	# 
	def init(params)
		require_relative 'modules/init_new'
		proceed_init
	end

	# 
	# Éditer le paradigme courant
	# 
	def edit(params)
		
	end
	
	# 
	# Construit le paradigme de field voulu
	# 
	def build(params)
		require_relative 'modules/build'
		proceed_build
	end

	# 
	# Retourne tous les paradigmes de field définis
	# 
	def all
		@all ||= begin
			Dir["#{film.pfa_folder}/*.yaml"].collect do |fpath|
				new(YAML.load_file(fpath))
			end.sort_by { |pfa| pfa.index }
		end
	end

	# 
	# Retourne le nombre courant de PFA
	# 
	def count
		all.count
	end

	# 
	# Retourne la liste Array pour Tty-prompt, pour choisir un
	# (ou plusieurs) PFA
	# 
	def all_for_tty_prompt
		all.collect do |pfa|
			{name: pfa.name, value: pfa}
		end
	end

	# 
	# Demande de choisir parmi des pfa
	# 
	def ask_for_pfa(question, multi = false, option_all = false)
		method = multi ? :multi_select : :select
		liste = all_for_tty_prompt
		liste << {name: "Tous", value: :all } if option_all
		liste << {name: "Renoncer", value: nil}
		choix = Q.send(method, question) do |q|
			q.choices liste
			q.per_page liste.count
		end
		if multi
			return if choix.include?(nil)
			if choix.include?(:all)
				return all
			else
				return [choix]
			end
		else
			return choix
		end
	end

end #/<< self
end #/class PFA