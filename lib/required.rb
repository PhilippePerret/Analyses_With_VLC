# encoding: UTF-8
# frozen_string_literal: true

require 'json'
require 'yaml'
require "readline"
require 'fileutils'
require 'tty-prompt'
Q = TTY::Prompt.new(symbols: {radio_on:"☒", radio_off:"☐"})

MAIN_FOLDER = File.dirname(__dir__)
LIB_FOLDER	= File.join(MAIN_FOLDER,'lib')
COMMANDS_FOLDER = File.join(LIB_FOLDER,'commandes')
MODULES_FOLDER 	= File.join(LIB_FOLDER,'modules')

# 
# Pour mettre les dates de derniers check ou d'enregistrement
# des fichiers de données du fichier courant
# 
LAST_DATE_CHECK = {}

require_relative './required/first/utils' # pour 'require_folder'
require_folder("#{LIB_FOLDER}/required/first")
require_folder("#{LIB_FOLDER}/required/then")