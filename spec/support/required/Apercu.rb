# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Pour piloter l'application Aperçu (par AppleScript)

=end
class Apercu

extend AppleScriptAppMethods

class << self
	

def app_name
	@app_name ||= "Preview"
end

end #/<< self
end