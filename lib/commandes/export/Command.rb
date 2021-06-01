# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'export', pour exporter les données

	L'export produit à la base un code HTML qui pourra ensuite être
	transformé en document PDF.

	Les options permettent de :
	---------------------------
	* n'exporter qu'un segment (from_time, to_time)
	* n'exporter qu'un type d'élément
	* produire un paradigme de Field
	
=end
class Commande
class << self

	def export(params = nil)
		require_module('export')
		film.export()
	end

end #/<< self
end