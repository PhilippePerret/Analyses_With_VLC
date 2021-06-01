# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Méthodes de formatage

=end

# 
# Remplace toutes les balises dans le string +str+, à commencer par
# les balises des personnages du film
# 
def formate(str)
	@reg_personnages ||= /\b(#{Personnage.table.keys.join('|')})\b/
	str.gsub(@reg_personnages){
		Personnage.get($1.freeze).cycled_name
	}
end