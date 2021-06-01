# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Class Marque
	------------
	Grande classe générique qui permet de mettre des marques de toute
	nature sur le film en collecte.
	Cf. le manuel.

=end
class Marque < FilmElement

# -------------------------------------------------------------------
#
#		CLASSE
#
# -------------------------------------------------------------------

def self.create(params)
	puts "-> Marque.create"
	require_module('marques/create')
	_create(params)
end


# -------------------------------------------------------------------
#
#		INSTANCE
#
# -------------------------------------------------------------------

def type; :marque end

# -------------------------------------------------------------------
#		VOLATILE DATA
# -------------------------------------------------------------------

def duree; end_time - time end
alias :duration :duree


# -------------------------------------------------------------------
#		EXTRA DATA
# -------------------------------------------------------------------
# 
# Type de la marque
# 
# Le type est propre au film et peut être défini à la volée, en 
# créant la marque.
# 
def mtype			;@mtype||=data[:ty]end

# 
# Temps de fin
# 
def end_time	;@end_time||data[:et]end



end #/class Marque