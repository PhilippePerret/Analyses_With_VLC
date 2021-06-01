# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Class TFilm
	------------
	Pour la gestion des films tests, dans le dossier support/assets/film

	#erase_scenes
		Détruit le fichier des scènes

=end
require_relative 'FilmElementsMethods.mod'

class TFilm

include FilmElementsMethods

# -------------------------------------------------------------------
#
#		CLASSE
#
# -------------------------------------------------------------------
class << self
	def folder
		@folder ||= File.join(SPEC_FOLDER,'assets','films')
	end
end #/<< self


# -------------------------------------------------------------------
#
#		INSTANCE
#
# -------------------------------------------------------------------
attr_reader :fname
def initialize(fname)
	@fname = fname
end

# 
# Préparation du film
# 
# C'est-à-dire, principalement, son ouverture dans VLC.
# 
def prepare
	tvlc.open_film(path)
	tell_me_to_activate
end


def collecte_folder
	@collecte_folder ||= File.join(main_folder,'collecte')
end
def affixe
	@affixe ||= File.basename(fname,File.extname(fname))
end
def main_folder
	@main_folder ||= File.join(self.class.folder,affixe)
end
def path
	@path ||= File.join(self.class.folder, fname)
end
end #/class TFilm