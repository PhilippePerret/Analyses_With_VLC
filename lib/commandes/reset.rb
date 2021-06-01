# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'reset', pour resetter toutes les données


=end
class Commande
class << self

	def reset(params = nil)
		Film.reset
		Personnage.reset
		Dir["#{film.folder}/**/*.*"].each do |fpath|
			LAST_DATE_CHECK.merge!(File.basename(fpath) => Time.now.to_i)
		end
	end

end #/<< self
end