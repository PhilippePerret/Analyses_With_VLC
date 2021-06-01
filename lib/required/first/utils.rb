# encoding: UTF-8
# frozen_string_literal: true

# 
# Active (met au premier plan) la fenêtre de Terminal
# 
def tell_me_to_activate
	`osascript -e 'tell application "Terminal" to activate'`
end


# 
# Prends le temps +time+, qui peut être une horloge avec frame, et
# retourne le nombre de secondes correspondant.
# 
def secondize(time)
	return time if time.is_a?(Integer)
	horloge, frames = time.split(',').collect{|n|n.strip}
	scs, mns, hrs = horloge.split(':').reverse.collect{|n|n.to_i}

	return ((scs + (mns||0) * 60 + (hrs||0) * 3600) * 1000 + (frames || 0)).to_f / 1000
end


# 
# Permet de définir un dossier en le créant s'il n'existe pas
# 
def mkdir(dirpath)
	`mkdir -p "#{dirpath}"`

	return dirpath
end

# 
# Pour écrire les données +ydata+ dans le fichier yaml +ypath+
# au format YAML
# 
def file_yaml_write(ypath, ydata)
	File.delete(ypath) if File.exist?(ypath)
	File.open(ypath,'wb'){|f|f.write(YAML.dump(ydata))}
end

# 
# Requiert tous les modules ruby du dossier +dossier+
# 
# +dossier+		{String} Path au dossier à requiérir
# +deep+			{Boolean} Si true, charge aussi les modules dans les
# 						sous dossier (défaut), sinon, ne charge que les modules
# 						à la racine du dossier.
# 
def require_folder(dossier, deep = true)
	dpath = "#{dossier}#{deep ? '/**' : ''}/*.rb"
	Dir[dpath].each{|m|require(m)}
end

# 
# Require un module (dans le dossier 'lib/modules')
# 
def require_module(module_name)
	require_folder(File.join(MODULES_FOLDER,module_name))
end

# 
# Écrit un message d'erreur et retourne FALSE
# 
def erreur(msg)
	puts msg.rouge
	return false
end


# 
# Pour nettoyer la console
# 
def clear
  puts "\n" # pour certaines méthodes
  puts "\033c"
end

