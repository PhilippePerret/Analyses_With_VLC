# encoding: UTF-8
# frozen_string_literal: true
=begin
	Définir dans ce module le code à jouer dans le film
	Il sera interprété tel quel
=end

# current_id = 0
# Film::TYPES_ELEMENTS.keys.each do |type|
# 	fpath = film.elements_file_path(type)
# 	next if not File.exist?(fpath)
# 	fname = File.basename(fpath)
# 	print "* Traitement du fichier #{fname}…".bleu
# 	fdata = YAML.load_file(fpath)
# 	fdata.each do |de|
# 		current_id += 1
# 		de.merge!(i: current_id)
# 	end
# 	puts "\r= Fichier #{fname} traité avec succès (current_id = #{current_id})".vert
# 	File.delete(fpath)
# 	File.open(fpath,'wb'){|f|f.write(YAML.dump(fdata))}
# 	# puts "\n\n--- fdata:\n#{fdata}"
# end
# film.update_hotdata(last_element_id: current_id)



