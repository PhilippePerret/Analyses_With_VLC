# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Pour piloter l'application Typora (par AppleScript)

=end
class Typora

extend AppleScriptAppMethods

class << self

# 
# Noter que c'est une méthode propre car path of documents ne
# fonctionne pas
# 
def docs_names
	cmd = <<-CODE
tell application "#{app_name}"
	return name of documents -- path ne fonctionne pas
end tell
	CODE
	run_osascript(cmd)
end

def app_name
	@app_name ||= "Typora"
end

end #/<< self
end