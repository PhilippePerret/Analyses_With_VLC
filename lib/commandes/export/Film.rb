# encoding: UTF-8
# frozen_string_literal: true
=begin

	Extension de la class Film pour l'exportation
	---------------------------------------------
	Ce module permet de produire les fichiers exportés des données
	rassemblées, au format HTML et/ou PDF.

=end

class Film

attr_reader :export_options

# 
# * main *
# 
# Méthode publique principale appelée pour exporter les données
# 
# +params+ {Hash} 	Tous les paramètres pour l'export
# 	:from_time			Temps de départ (default: 0)
# 	:to_time				Temps de fin (default: fin du film)
# 	:offset_time		Le décalage en secondes pour chaque temps
# 									Rappel : tous les temps sont toujours enregistrés
# 									par rapport au temps réel de la vidéo. On détermi-
# 									ne ensuite un "point zéro" qui permet de savoir où
# 									le film commence réellement
# 	:output_format	Format de sortie
# 									Pour le moment, seul 'html' est possible.
# 	:only						{Array} Une liste contenant les seuls types à 
# 									exporter. Parmi 'scene', 'note', 'info' (tous les
# 									types d'éléments que peut contenir le film)
# 	:except					{Array} L'inverse de la précédente, pour supprimer
# 									un type d'éléments.
# 
def export(params = nil)

	params ||= {}

	# 
	# On expose les options d'exportation
	# 
	@export_options = params

	# 
	# Il faut d'abord rassembler tous les éléments
	# 
	es = collect_all_elements

	# 
	# On les classe par temps
	# 
	es = es.sort_by { |e| e.time }

	# 
	# On rentre les éléments dans leur scène respective
	# Pour ce faire, on boucle sur la liste des éléments classés ci-
	# dessus. Quand on rencontre une scène, on la met en scène courante
	# et tous les éléments suivants lui sont attribués, jusqu'à la
	# scène suivante.
	# 
	scene_courante = nil
	scs = []
	es.each do |e|
		if e.type == :scene
			scene_courante = e
			scs << e
		elsif scene_courante
			scene_courante.items << e
		else
			puts "Aucune scène n'est définie pour placer l'élément #{e}…".rouge
		end
	end

	# 
	# Maintenant que les éléments ont été mis dans les scènes, on 
	# peut produire le code HTML principal
	# 
	File.delete(prov_html_export_file) if File.exist?(prov_html_export_file)
	ff = File.open(prov_html_export_file,'a')
	begin
		scs.each_with_index do |sc, idx|
			ff << sc.to_html(idx + 1)
		end
	rescue Exception => e
		puts e.message.rouge
		puts e.backtrace.join("\n").rouge
	ensure
		ff.close
	end

	#
	# On finalise le document
	# 
	doc = AWV::Document.new()
	doc.build

	# 
	# On produit le document PDF
	# 
	to_pdf(html_export_file, pdf_export_file)

	nettoyage

	puts "= Film exporté avec succès. =".vert

	`open -a Finder "#{pdf_export_file}"`
end


def nettoyage
	File.delete(prov_html_export_file) if File.exist?(prov_html_export_file)
end

def collect_all_elements
	es = []
	TYPES_ELEMENTS.keys.each do |etype|
		# 
		# On ne prend pas les types d'éléments exclus
		# 
		next if (export_options[:only] && !export_options[:only].include?(etype)) || (export_options[:except] && export_options[:except].include?(etype))
		es += elements(etype)
	end

	return es
end

# 
# Produit le fichier PDF des données exportées
# 
# +src_html+		Chemin d'accès absolu au fichier source (HTML)
# +dest_pdf+		Chemin d'accès absolu au fichier de destination (PDF)
def to_pdf(src_html, dest_pdf)
	print "* création du PDF, merci de patienter…".bleu
	File.delete(dest_pdf) if File.exist?(dest_pdf)
	res = `/usr/local/bin/wkhtmltopdf "file://#{src_html}" "#{dest_pdf}" 2>&1`
	if not res.empty?
		puts "\r#{res}".rouge
	else
		puts "\r= PDF créé avec succès                 \n".vert
	end
end


def prov_html_export_file
	@prov_html_export_file ||= File.join(export_folder, 'export-prov.html')
end
def pdf_export_file
	@pdf_export_file ||= File.join(export_folder,'export.pdf')
end
def html_export_file
	@html_export_file ||= File.join(export_folder,'export.html')
end
end #/Film