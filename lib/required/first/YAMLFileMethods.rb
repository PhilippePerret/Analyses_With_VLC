# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	
	Module de méthode pour tous les fichiers YAML de collecte.
	Et les fichiers de configuration et de hotdata

	Les méthodes qu'ils partagent.

	METHODS
	-------
		(note : il s'agit de méthode de classe, le module sera étendu)

		update_data(hdata)
			Permet d'actualiser les données
		
		data
			Retourn les données
		
		save
			Enregistre les données
			
		count
			Retourne le nombre d'instance actuel

		get(id)
			Retourne l'instance +id+ de la classe.

		table
			Retourne une table des instances avec en clé l'identifiant
			de l'instance et en valeur son instance

		show_list
			Affiche la liste des instances
			On peut définir LIST_ENTETE à mettre en entête de la liste

		edit
			Permet d'éditer le fichier YAML dans l'éditeur défini en
			configuration par YAML_EDITOR.

		count
			Retourne le nombre d'instance (all)

		sans_action
			Quand la classe est appelée sans méthode. Par exemple 'note'.


	REQUIS
	------
		(Chaque classe incluant ce module doit définir ces propriétés et
		 méthodes.)

		class::yaml_file_path
	
				Chemin d'accès au fichier contenant les données YAML

		class:all

				Doit renvoyer une liste {Array} de toutes les instances,
				dans l'ordre de leur enregistrement.

		class::yaml_data

				Toutes les données à enregister dans le fichier YAML
				En général, toutes les @data des instances

		class#to_console

				Une méthode d'instance pour afficher l'instance dans le
				listing des instances.

=end

module YAMLFileMethods

	# 
	# Retourne l'instance Personnage du personnage d'identifiant +pid+
	# 
	def get(iid)
		table[iid]
	end

	# 
	# Retourne la table des instances, avec en clé l'identifiant
	# et en valeur son Instance.
	# 
	def table
		@table ||= begin
			h = {};all.each{|i|h.merge!(i.id => i)};h
		end
	end

	# 
	# Met le fichier YAML en édition
	# 
	# +params+ ne sert à rien, mais il est envoyé par certaines classes
	# qui envoient les paramètres de la ligne de commande à toutes leurs
	# méthodes.
	# 
	def edit(params = nil)
		if File.exist?(yaml_file_path)
			`open -a "#{YAML_EDITOR}" "#{yaml_file_path}"`
		else
			erreur("Le fichier '#{yaml_file_path}' n'existe pas encore, je ne peux pas l'éditer.")
		end
	end

	# 
	# Sauve toutes les données de toutes les instances dans le fichier
	# YAML
	# 
	def save
		file_yaml_write(yaml_file_path,yaml_data)
	end

	# 
	# Actualise la donnée +data+ en mergeant les données +hdata+
	# 
	# Note : pour les fichiers qui définissent @data comme le fichier
	# de configuration ou de hotdata
	# 
	def update_data(hdata = nil)
		@data || data
		@data.merge!(hdata) unless hdata.nil?
		file_yaml_write(yaml_file_path,data)
	end

	# 
	# Retourne les données du fichier yaml_file_path (quand c'est
	# une table, comme pour les configurations ou les hotdata par 
	# exemple)
	# 
	def data
		@data ||= begin
			if File.exist?(yaml_file_path)
				YAML.load_file(yaml_file_path)
			else
				{}
			end
		end
	end

	# 
	# Affiche en console la liste des instances
	# 
	def show_list
		clear
		puts "= LISTE DES INSTANCES #{name} =".bleu
		puts "\n\n"
		len_delim = defined?(LIST_ENTETE) ? LIST_ENTETE.length + 2 : 80
		delim = ("-"*len_delim).bleu
		if defined?(LIST_ENTETE)
			puts delim
			puts LIST_ENTETE 
		end
		puts delim
		all.each do |inst|
			puts "  #{inst.to_console}"
		end
		puts delim
		puts "\n\n"
	end
	alias :list :show_list

	# 
	# {Array of Instance}
	# 
	# Retourne la liste {Array} de toutes les instances de la
	# classe
	# 
	def all
		@all ||= begin
			if File.exist?(yaml_file_path)
				YAML.load_file(yaml_file_path).collect {|de| new(de)}
			else 
				[] 
			end
		end
	end
	alias :yaml_data :all

	# 
	# Nombre d'instances actuelle
	# 
	def count
		all.count
	end

	# 
	# Préfixe
	# 
	# Ce préfixe permet de faire référence à l'élément, par la formule :
	# 	<prefixe><id élément>
	# 
	# Il se compose des trois premières lettres majuscule de la classe
	# 
	def ref_prefix
		@ref_prefix ||= name.split('::').last[0..2].upcase.freeze
	end

	def sans_action
		action = Q.select("Que voulez-vous faire des éléments #{name} ?") do |q|
			q.choices ACTIONS
			q.per_page ACTIONS.count
		end || return
		self.send(action)
	end

	ACTIONS = {
		"Liste des éléments" => :list,
		"Éditer les éléments" => :edit,
		"Renoncer" => nil
	}
end #/module YAMLFileMethods