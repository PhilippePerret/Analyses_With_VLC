# encoding: UTF-8
# frozen_string_literal: true
=begin
	class Document
	---------------
	Le document exporté

=end
require 'erb'

class AWV
class Document
	
	# 
	# Méthode principale qui construit le document pour le film
	# 
	def build
		code = ERB.new(File.read(template_path).force_encoding('utf-8')).result(self.bind)
		File.open(film.html_export_file,'wb'){|f|f.write(code)}
	end

	# -------------------------------------------------------------------
	#
	#		Helpers methods pour le template
	#
	# -------------------------------------------------------------------

	def bind; binding() end

	def title
		film.infos[:title]
	end

	def body
		File.read(film.prov_html_export_file).force_encoding('utf-8')
	end

	def css
		if not(File.exist?(css_file)) || (File.stat(css_file).mtime < File.stat(sass_file).mtime)
			require 'sass'
		  data_compilation = {line_comments: false, style: :compressed}
  		Sass.compile_file(sass_file, css_file, data_compilation)
		end
		File.read(css_file).force_encoding('utf-8')
	end

	# -------------------------------------------------------------------
	#
	#		Paths
	#
	# -------------------------------------------------------------------

	# 
	# Chemin d'accès fichier Template
	# 
	def template_path
		@template_path ||= begin
			File.join(__dir__,'template.erb')
		end
	end

	# 
	# Chemin d'accès au fichier CSS
	# 
	def css_file
		@css_file ||= File.join(__dir__,'styles.css')
	end
	def sass_file
		@sass_file ||= File.join(__dir__,'styles.sass')
	end

end #/class Document
end #/class AWV