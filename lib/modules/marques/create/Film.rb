# encoding: UTF-8
# frozen_string_literal: true
=begin
	Extension de Film pour les marques
=end
class Film

# 
# {Hash}
# 
# Retourne la table des types de marques
# 
def types_marques
	infos[:types_marques] || {}	
end

# 
# {Hash}
# 
# Retourne la table permettant de choisir un type de marque dans la
# liste des marques du film.
# 
def types_marques_for_ttyprompt
	@types_marques_for_ttyprompt ||= begin
		h = {}
		types_marques.each{|markid, marklabel|h.merge!(marklabel => markid)}
		h.merge!("Nouveau type…" => :new, "Renoncer" => nil)
	end
end
end #/class Film

