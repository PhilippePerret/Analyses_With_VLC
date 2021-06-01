# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Matchers pour VLC

=end

class VLC
class << self

	# 
	# Pour la formule :
	# 
	# 	expect(VLC).to be_playing
	# 
	def playing?
		return eval(vlc("return playing").strip) == true
	end

	# 
	# Pour la formule :
	# 
	# 	expect(VLC).to have_current_time(<time>)
	# 
	def has_current_time?(time)
		sleep 1 # toujours lui laisser le temps
		ct = VLC.current_time
		ok = ct.between?(time - 2, time + 2)
		if not ok
			puts "Le temps de VLC devrait être entre #{time-2} et #{time+2}, et c'est #{ct}".rouge
		end

		return ok
	end

end #/<< self
end #/class VLC