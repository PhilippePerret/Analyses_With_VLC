# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Class AWV::Intrigue
	-------------------
	Gestion des intrigues

=end
class AWV::Intrigue

	extend YAMLFileMethods

	ACTIONS_OF_COMMAND = {
		"Afficher la liste des intrigues" 	=> :list,
		"Instancier une nouvelle intrigue" 	=> :init,
		"Dispatcher les scènes dans les intrigues" => :dispatch,
		"Renoncer" =>  nil
	}

	TYPES = {
		princ: 	{name: "Intrigue principale", value: :princ},
		amour: 	{name: "Intrigue amoureuse", value: :amour},
		secon: 	{name: "Intrigue secondaire", value: :secon},
		obvie: 	{name: "Objectif de vie du protagoniste", value: :obvie},
		autre: {name: "Autre intrigue", value: :autre}
	}

# -------------------------------------------------------------------
#
#		CLASSE
#
# -------------------------------------------------------------------
class << self

	# 
	# Fichier intrigue.yaml contenant la définition des intrigues
	# 
	def yaml_file_path
		@yaml_file_path ||= File.join(film.collecte_folder,'intrigues.yaml')
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
end

# -------------------------------------------------------------------
#
#		HELPERS
#
# -------------------------------------------------------------------

def to_console
	"#{"#{self.class.ref_prefix}#{id}".to_s.rjust(7)} #{type.to_s.ljust(6)} #{titre.ljust(30)}"
end
# -------------------------------------------------------------------
#
#		DATA
#
# -------------------------------------------------------------------

def id					;@id||=data[:id]end
def titre				;@titre||=data[:titre]end
def type				;@type||=data[:type]end
def description	;@description||=data[:description]end

end #/class AWV::Intrigue