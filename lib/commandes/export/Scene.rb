# encoding: UTF-8
# frozen_string_literal: true
=begin
	Extension de la class Scene pour l'export
=end
class Scene

def to_html(numero = nil)
	<<-HTML
<div class="film-element #{type}">
	<div class="horloge">#{time.to_horloge}</div>
	<div class="resume"><span class="scene-number">#{numero ? "#{numero}. " : ''}</span>#{formated_resume}</div>
	<div class="items">#{items_formated}</div>
</div>
	HTML
end

# 
# Le formatage spécial du résumé
# ------------------------------
# En plus des formatages habituels, on prend la première phrase pour
# la mettre en gras.
def formated_resume
	suivantes = epured_resume.split('.')
	premiere 	= suivantes.shift
	suivantes	= suivantes.join('.')
	formate("<strong>#{premiere}.</strong>#{suivantes}")
end

def items_formated
	items.collect do |i|
		i.to_html
	end.join('')
end

end #/class Scene
