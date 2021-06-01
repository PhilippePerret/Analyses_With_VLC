# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	class Personnage
	----------------

=end

class Personnage

extend YAMLFileMethods

LIST_ENTETE = "  #{'ID'.ljust(5)}#{'PSEUDO'.ljust(20)}#{'PATRONYME'.ljust(30)}FONCTION"

# -------------------------------------------------------------------
#
#		CLASSE
#
# -------------------------------------------------------------------
class << self


	# 
	# Retourne la liste {Array} des identifiants {String} de personnage
	# qu'on trouve dans +str+
	# 
	def ids_in(str)
		@reg_ids_personnages ||= /\b(#{table.keys.join('|')})\b/
		str.scan(@reg_ids_personnages).to_a.collect{|e|e[0]}.uniq
	end

	# 
	# Pour actualiser les données
	# 
	def reset
		@data 	= nil
		@all 		= nil
		@table	= nil
		@reg_ids_personnages = nil
	end

	# 
	# Retourne les données du fichier personnage
	# 
	def data
		@data ||= begin
			if File.exist?(yaml_file_path)
				YAML.load_file(yaml_file_path)
			else
				puts "Le fichier '#{yaml_file_path}' n'est pas défini, il n'y a pas de personnages."
				[]
			end
		end
	end

	def yaml_file_path
		@yaml_file_path ||= File.join(film.folder, 'personnages.yaml')
	end
end #/<< self

# -------------------------------------------------------------------
#
#		INSTANCE
#
# -------------------------------------------------------------------

attr_reader :data

def initialize(data)
	@data = data

	# Pour le nom cyclique du personnage dans les textes
	@idx_cycle = 0

end

# -------------------------------------------------------------------
#
#		HELPERS METHODS
#
# -------------------------------------------------------------------

# 
# Retourne un nom pour le personnage qui alternera entre son
# pseudo et son patronyme.
# 
def cycled_name
	@idx_cycle += 1
	nom_cyclique =
	if @idx_cycle == 0
		patronyme
	else
		@idx_cycle % 4 == 0 ? patronyme : pseudo
	end
	nom_cyclique
end

# 
# Pour un affichage du personnage en console
# Par exemple lorsqu'on demande la liste des personnages
# 
def to_console
	"#{id.ljust(5)}#{pseudo.ljust(20)}#{patronyme.ljust(30)}#{fonction}"
end

# -------------------------------------------------------------------
#
#		DATA
#
# -------------------------------------------------------------------
def id ; @id ||= data[:id] end
def pseudo ; @pseudo ||= data[:pseudo] end
def patronyme ; @patronyme ||= data[:patronyme] end
def fonction ; @fonction ||= data[:fonction] end

end #/class Personnage