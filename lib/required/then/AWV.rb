# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	class AWV
	---------
	L'application proprement dite

=end

class AWV
class << self

	def init
		clear
		
		# 
		# Panneau à afficher en fonction de la dernière ouverture de
		# l'application.
		# 
		# Si on l'a ouvert depuis moins d'une heure, on ne fait rien.
		# Si on l'a ouvert depuis moins d'un jour, on affiche un panneau
		# minimal.
		# Si on l'a ouverte depuis plus longtemps, on affiche le panneau
		# complet qui explique bien les choses.
		# 
		now = Time.now.to_i
		last_launch = hotdata[:last_launched_at]
		
		if last_launch.nil? || last_launch < now - 7.days
		
			puts panneau_integral
		
		elsif last_launch < now - 1.day 
		
			puts panneau_reduit
		
		end

		film.backup_if_necessary
		tell_me_to_activate

		# 
		# Dans tous les cas on enregistre la date de dernière ouverture
		# 
		# update_hotdata(last_launched_at: Time.now.to_i)

	end

	# 
	# Analyse la commande passée
	# Retourne le premier mot et les paramètres qui seront transmis
	# 
	# +buf+	{String} La commande entrée en console
	# 
	# Produit +params+ qui va contenir :
	# 
	# 	:as_sentence		Si des paramètres sont transmis après le premier
	# 									mot (commande), ils sont rassemblés comme phrase
	# 									dans cette propriété, car ça peut être une 
	# 									phrase comme à la création des éléments.
	# 
	# 	:word_count			Le nombre de mots, sans compter le premier, qui
	# 									est la commande.
	# 
	# 	:options				Les options passées, sous forme '-' ou '--'
	# 
	# 	1 à X						Les x "mots" passés, hors option.
	# 
	# Par exemple, si la commande suivante est passée :
	# 
	# 	create scene Une scène -fk pour voir si -v ça marche
	# 
	# Alors on aura :
	# 
	# 	params = {
	# 		1 => 'scene', 2 => 'Une', 3 => 'scène', 4 => 'pour'
	# 		5 => 'voir', 6 => 'si', 7 => 'ça', 8 => 'marche',
	# 		options: {fake: true, verbose: true},
	# 		as_sentence: "scene Une scène pour voir si ça marche"
	# 	}
	# 
	def parse_command(buf)
		words = buf.split(' ')

		# 
		# Le premier mot, qui est la commande proprement dite
		# 
	  word1 = words.shift
	  word1 = ALT_COMMAND_TO_REAL[word1] || word1

  	params 	= {options: {}}
  	mots 		= []
	  words.each do |word|

	  	if word.start_with?('--')
	  	
	  		opt = word[2..-1]
	  		if opt.match?(/=/)
	  			opt, value = opt.split('=')
	  			value = value.gsub(/^['"]?(.*?)['"]?$/,'\1')
	  		else
	  			value = true
	  		end
	  		params[:options].merge!( opt.to_sym => value)
	  	
	  	elsif word.start_with?('-')
	  	
	  		params[:options].merge!(OPTIONS_SHORT_TO_LONG[word[1..-1].to_sym] => true)
	  	
	  	else
	  	
	  		mots << word
	  		params.merge!( mots.count => word )
	  	
	  	end
	  
	  end

	  if not mots.empty?
	  	params.merge!(as_sentence: mots.join(' '), word_count:mots.count)
	  end

  	return [word1, params]
	end


# -------------------------------------------------------------------
#
#		HOT DATA
#
# Gestion des données "chaudes" comme par exemple le dernier film
# joué ou la dernière commande exécutée.
# 
# Pour obtenir une donnée chaude :
# 	d = AWV.hotdata[key]
# 
# Pour enregistrer une donnée chaude :
# 	AWV.update_hotdata(key => value)
# 	AWV.save.hotdata(key => value)
# 
# -------------------------------------------------------------------

def update_hotdata(hdata)
	@hotdata || hotdata # pour forcer son chargement au cas où
	@hotdata.merge!(hdata) unless hdata.nil? || hdata.empty?
	file_yaml_write(hotdata_file,hotdata)
end
alias :save_hotdata :update_hotdata

def hotdata
	@hotdata ||= begin
		if File.exist?(hotdata_file)
			YAML.load_file(hotdata_file)
		else
			{
				last_command: nil,
				last_film_path: nil
			}
		end
	end
end
def hotdata_file
	@hotdata_file ||= File.join(MAIN_FOLDER,'hotdata.yaml')
end


def panneau_integral
	p = File.join(assets_folder,'panneaux','integral.txt')
	return prepare_tableau(p)
end

def panneau_reduit
	p = File.join(assets_folder,'panneaux','minimal.txt')
	return prepare_tableau(p)
end

def prepare_tableau(p)
	"  " + eval("%Q{#{File.read(p).force_encoding('utf-8')}}")
	.split("\n")
	.join("\n  ")
end


def assets_folder
	@assets_folder||=File.join(LIB_FOLDER,'assets')
end
end #/<< self
end #/class AWV

class String
	def as_console
		"🎞  #{self}".jaune
	end
end