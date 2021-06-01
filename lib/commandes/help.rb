# encoding: UTF-8
# frozen_string_literal: true
=begin
	Commande 'help'
=end
class Commande
class << self

	def help(params = nil)
		version_md, version_pdf = params[:options][:development] ? [manuel_dev_md_path, manuel_dev_pdf_path] : [help_md_path, help_pdf_path]
		fpath = params[:options][:write] ? version_md : version_pdf
		`open -a Finder "#{fpath}"`
	end

	def help_md_path
		@help_md_path ||= File.join(manuel_folder,'Manuel.md')
	end

	def help_pdf_path
		@help_pdf_path ||= File.join(manuel_folder,'Manuel.pdf')
	end

	def manuel_dev_md_path
		@manuel_dev_md_path ||= File.join(manuel_folder,'Manuel_developpeur.md')
	end

	def manuel_dev_pdf_path
		@manuel_dev_pdf_path ||= File.join(manuel_folder,'Manuel_developpeur.pdf')
	end

	def manuel_folder
		@manuel_folder ||= File.join(MAIN_FOLDER,'Manuel')
	end

end #/<< self
end #/Commande
