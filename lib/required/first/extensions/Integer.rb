# encoding: UTF-8
# frozen_string_literal: true
=begin
	Extension de la class Integer
=end

class Integer

	def days
		self * 3600 * 24
	end
	alias :day :days

	# 
	# Transforme l'entier en horloge
	# 
	def to_h(as_duree = false)
		s = self
		h = (s / 3600).to_s
		s = s % 3600
		m = (s / 60).to_s.rjust(2,'0')
		s = (s % 60).to_s.rjust(2,'0')
		if as_duree
			"#{h.to_i > 0 ? "#{h}:" : ''}#{m}:#{s}"
		else
			"#{h}:#{m}:#{s}"
		end
	end
	alias :to_horloge :to_h

end #/Integer