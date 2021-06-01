# encoding: UTF-8
# frozen_string_literal: true
=begin
Extension de la classe abstraite FilmElement pour l'export de
l'analyse.
=end
class FilmElement

# 
# Retourne l'élément pour l'export
# 
# Note : l'élément est surclassé pour les scènes
def to_html
	<<-HTML
<div class="film-element #{type}">
	<span class="resume"><span class="element-type">#{type.upcase}</span><span class="horloge">#{time.to_horloge}</span>#{formate(epured_resume)}</span>
</div>
	HTML
end

# 
# Retourne le code pour une sortie console de l'élément, pour le
# suivi.
# 
def to_console
	"#{htime} #{resume}"
end

def htime
	@htime ||= time.to_horloge
end


end #/class FilmElement
