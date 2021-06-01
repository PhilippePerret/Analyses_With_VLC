# encoding: UTF-8
# frozen_string_literal: true
=begin
	Extension de la classe String
=end
class String

	# 
	# Transforme une horloge en secondes
	# 
	def to_sec
		h, f = self.split(',')
		h, m, s = h.split(':').reverse
		s.to_i + (m||0) * 60 + (h||0) * 3600
	end

end
