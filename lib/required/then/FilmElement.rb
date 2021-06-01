# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	class FilmElement
	-----------------
	Classe abstraite dont hérite tout élément de film, scène, note, 
	etc.

=end
class FilmElement

	extend YAMLFileMethods

# -------------------------------------------------------------------
#
#		CLASSE
#
# -------------------------------------------------------------------
class << self

	# 
	# Création de l'élément pour le film
	# 
	def create(resume, time = nil)
		element = new({
			r:resume, t:(time || VLC.current_time), i: film.get_new_id
		})
		film.insert_element(element)
	end

	# 
	# Chemin d'accès au fichier YAML (pour YAMLFileMethods)
	def yaml_file_path
		@yaml_file_path ||= film.elements_file_path(name.downcase)
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

def ref_prefix
	@ref_prefix ||= self.class.ref_prefix
end

def tag
	@tag ||= "#{ref_prefix}#{id}"
end
def ref(raccourci = true)
	hresume = raccourci ? real_resume[0..40] : real_resume
	"#{tag}:#{time.to_h}#:{hresume}"
end

def real_resume
	@real_resume ||= resume.split('.').first
end

# 
# Retourne un résumé pour le listing TTY-Prompt
def resume_tty
	if resume.length > 60
		resume[0..59] + '…'
	else
		resume
	end
end

#
# Retourne le résumé "épuré", c'est-à-dire sans la portion optionnelle
# placée après un '|' qui définit les données cachées
# 
def epured_resume
	@epured_resume ||= resume.split('|')[0]
end


# -------------------------------------------------------------------
#
#		VOLATILE DATA
#
# -------------------------------------------------------------------

# 
# Les éléments contenus par cet élément. Principalement utilisé
# pour les scènes
# 
def items
	@items ||= []
end

# 
# Les instances de personnages en relation avec cet élément
# 
def personnages
	@personnages ||= personnages_ids.collect{|pid|Personnage.get(pid)}
end

# 
# Identifiants personnages trouvés dans le résumé
# 
def personnages_ids
	@personnages_ids ||= Personnage.ids_in(resume)
end

# -------------------------------------------------------------------
#
#		HELPERS
#
# -------------------------------------------------------------------

# 
# La méthode par défaut pour afficher les éléments de ce type
# 
def to_console
	"#{"#{self.class.ref_prefix}#{id}".ljust(7)} #{time.to_h} #{resume}"
end

# -------------------------------------------------------------------
#
#		DATA
#
# -------------------------------------------------------------------

def id
	@id ||= data[:i]
end

def time
	@time ||= data[:t]
end

def resume
	@resume ||= data[:r]
end

def description
	@description ||= data[:d]
end


end #/class FilmElement