# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Class Config
	-------------
	Pour la configuration générale de l'application

=end
class Config

extend YAMLFileMethods

class << self

	# 
	# Retourne la valeur de configuration +key+
	# 
	# Par exemple :
	# 
	# 	Config[:yaml_editor]
	# 
	def [](key)
		data[key]
	end


	def yaml_file_path
		@yaml_file_path ||= File.join(MAIN_FOLDER,'config.yaml')
	end
end #/<< self
end #/class Config