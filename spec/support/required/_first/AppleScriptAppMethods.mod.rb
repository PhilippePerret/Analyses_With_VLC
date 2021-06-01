# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Module contenant des méthodes pour les applications par
	applescript

	L'application qui extend ce module doit définir la propriété de
	class 'app_name', le nom de l'application.

=end


module AppleScriptAppMethods

def close_all
	cmd = <<-CODE
tell application "#{app_name}"
	close documents
end
CODE
	run_osascript(cmd)
end

def docs_names
	cmd = <<-CODE
tell application "#{app_name}"
	return path of documents
end tell
	CODE
	run_osascript(cmd)
end


def run_osascript(cmd)
	final_cmd = <<-CODE
osascript <<TEXT
#{cmd}
TEXT
	CODE

	return `#{final_cmd}`.strip
end

end #/module AppleScriptAppMethods