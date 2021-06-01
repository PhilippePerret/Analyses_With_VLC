# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Module contenant toutes les méthodes de traitement des éléments du
	film, scènes, informations, marqueurs, etc.

=end
module FilmElementsMethods

# ------------------------------------------------------------------
#
#		SCÈNES
#
# ------------------------------------------------------------------

# 
# Construit des scènes pour les films avec les paramètres +params+
# Et retourne la liste des scènes construites ({Array de Hash}.
# 
# +params+
# 
# 	Si Integer, c'est le nombre de scènes à créer (lorsque l'on se
# 	fiche des résumés, des temps, etc.)
# 	Sinon, c'est une table Hash pouvant contenir :
# 
# 	:count 			Le nombre de scène à construire
# 	:times			{Array} Les temps à donner aux scènes 
# 							(surclasse :count)
# 	:data				{Array} Liste des données de scènes à construire, par
# 							exemple avec leur résumé et leur temps :
# 							data: [
# 								{t:10, 	r: "Mon résumé"},
# 								{t:100, r: "Mon résumé"},
# 							]
# 							(surclasse :count et :time)
# 
def build_scenes(params)
	params = {count:params} if params.is_a?(Integer)
	data =
	if params.key?(:data)
		params[:data]
	elsif params.key?(:times)
		params[:times].collect do |time|
			resume = "Un résumé au temps #{time}"
			{t: time, r: resume}
		end
	elsif params.key?(:count)
		time = 10
		params[:count].times.collect do |i|
			time += 100 + rand(100)
			{r:"Résumé au temps #{time}", t: time}
		end
	end
	save_yaml_data('scenes', data)

	return data
end

# 
# Détruit toutes les scènes du film
# 
def erase_scenes
	erase_yaml_file('scenes')
end


#
# Enregistre le fichier YAML d'affixe +afile+ dans le dossier 
# +dossier+ ('collecte' par défaut) avec les données data
# 
def save_yaml_data(afile, ydata, dossier = 'collecte')
	p = erase_yaml_file(afile, dossier)
	File.open(p,'wb'){|f|f.write(YAML.dump(ydata))}
end

# 
# Détruit le fichier YAML d'affixe +afile+ dans le dossier +dossier+
# qui est le dossier collecte par défaut
# 
# Retourne le path du fichier détruit
# 
def erase_yaml_file(afile, dossier = 'collecte')
	p = File.join(main_folder, dossier, "#{afile}.yaml")
	File.delete(p) if File.exist?(p)

	return p
end

end #/module FilmElementsMethods