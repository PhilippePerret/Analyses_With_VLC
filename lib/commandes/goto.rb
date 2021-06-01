# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Commande 'goto'
	---------------
	Script qui gère tout ce qui concerne la commande 'goto'

=end
class Commande
class << self

	def goto(params)
		time = params[1] || choose_a_time || return
		VLC.goto(secondize(time), params)
	end

end # /<< self
end #/Commande