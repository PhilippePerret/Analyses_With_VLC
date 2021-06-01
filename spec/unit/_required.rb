# encoding: UTF-8
# frozen_string_literal: true
=begin
	Requis pour tous les tests de ce dossier
=end

APP_PATH 		= File.dirname(File.dirname(__dir__))

# 
# Dossier principal des tests
# 
SPEC_FOLDER = File.join(APP_PATH,'spec')

# 
# L'entrée du programme
# 
MAIN_SCRIPT_PATH = File.join(APP_PATH, 'main.rb')

# 
# L'extrait de film qui permet de faire les tests
# 
EXTRAIT_FILM_PATH = File.expand_path('./spec/assets/film/default_film.mkv')


