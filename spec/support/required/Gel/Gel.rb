# encoding: UTF-8
# frozen_string_literal: true
=begin
	Classe Gel
	----------
	Qui permet de produire les gels et dégels
=end
class Gel
class << self

	def gel_init_state
		gel('init_state', "État initial de l'application, avant le début des tests.")
	end

	def degel_init_state
		degel('init_state')
	end

	# 
	# Produit le gel de nom +gel_name+ à partir de l'état courant
	# de l'application
	# 
	def gel(gel_name, description)
		new(gel_name).gel(description)
	end

	# 
	# Produit le dégel du gel de nom +gel_name+
	# 
	def degel(gel_name)
		new(gel_name).degel
	end

	# 
	# Path au dossier contenant les gels
	# 
	def folder
		@folder ||= mkdir(File.expand_path(File.join('.','spec','support','gels')))
	end
end#/<< self

# -------------------------------------------------------------------
#
#		INSTANCE
#
# -------------------------------------------------------------------

attr_reader :name

def initialize(name)
	@name = name
end


# 
# Procède au gel de description +description+
# 
def gel(description = nil)

	# 
	# Enregistrement de la description
	# 
	description || ""
	description = "GEL #{name}\nDU #{Time.now}\n\n#{description}"
	File.open(description_path,'wb'){|f|f.write(description)}

	# *** Fichier de configuration ***
	gel_file('config.yaml')

	# *** Fichier de hot data ***
	gel_file('hotdata.yaml')

end

# 
# Méthode pour procéder au dégel du gel
# 
def degel
	
	# *** Fichier de configuration ***
	degel_file('config.yaml')

	# *** Fichier de hot data ***
	degel_file('hotdata.yaml')

end

# -------------------------------------------------------------------
#		MÉTHODES DE GEL
# -------------------------------------------------------------------

def gel_file(path)
	src = path.start_with?('/') ? path : File.join(MAIN_FOLDER,path)
	dst = File.join(folder, path)
	File.delete(dst) if File.exist?(dst)
	return if not File.exist?(src)
	mkdir(File.dirname(dst))
	file_copy(src,dst)
end

def degel_file(path)
	src = File.join(folder, path)
	dst = path.start_with?('/') ? path : File.join(MAIN_FOLDER,path)
	File.delete(dst) if File.exist?(dst)
	return if not File.exist?(src)
	file_copy(src,dst)
end

def file_copy(src,dst)
	if File.directory?(src)
		FileUtils.cp_r(src, dst)
	else
		FileUtils.cp(src,dst)
	end
end
# -------------------------------------------------------------------
#		CHEMINS D'ACCÈS
# -------------------------------------------------------------------

# 
# Path au fichier de description du gel
# 
def description_path
	@description_path ||= File.join(folder,'description.txt')
end

# 
# Path du dossier du gel
# 
def folder
	@folder ||= mkdir(File.join(self.class.folder,name))
end
end#/class Gel