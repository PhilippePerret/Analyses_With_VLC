# encoding: UTF-8
# frozen_string_literal: true
=begin
	Extension de Marque pour créer une nouvelle marque
=end
class Marque
class << self
	def _create(params)
		params = define_type_new_marque(params) || return
		type = params[:type]
		resume 		= define_resume_in(params) || return
		end_time	= define_end_time(VLC.command_time) || return
		mdata = {
			i:  film.get_new_id,
			ty: type,
			t:  VLC.command_time,
			et: end_time,
			r:  resume,
		}	
		film.insert_element(new(mdata))
	end



	# 
	# {Hash}
	# 
	# Méthode qui reçoit le premier mot de la commande de création d'une
	# marque — qui doit donc être le type 
	# Retourne le bon type de la marque
	# 
	# +params+	Les paramètres de la commande. On les envoie et on les
	# 					retourne pour gérer le cas où le type a été oublié et que
	# 					le premier mot fait partie du résumé de la marque.
	# 					Par exemple, si le collecteur a rentré :
	# 							$> m Ma première marque
	# 					… alors l'application pense que 'Ma' est le type de la
	# 					marque. Comme il ne la trouve pas, il demande si c'est un
	# 					nouveau type. Le collecteur doit répondre que non. Dans ce
	# 					cas, ce mot est laissé dans la sentence.
	# 					Sinon, si c'est vraiment une nouvelle marque
	# +type+	Si type déjà connu, on le renvoie directement
	# 				Si non défini, on demande de le choisir parmi les types 
	# 				déjà définis ou de le créer
	# 
	def define_type_new_marque(params)
		type = params[1]
		if type.nil?
			# Traité plus bas
		elsif film.types_marques.keys.include?(type)
			params[:type] = type
		else
			if Q.yes?("Le type #{type.inspect} est-il vraiment un nouveau type de marque ?")
				create_new_type_marque(type: type) || return
				params[:type] = type
			end
		end

		return params if params[:type]

		# 
		# Si on passe ici, c'est qu'il faut demander le type de marque
		# 
		if film.types_marques.empty?
			type = create_new_type_marque
		else
			type = Q.select("Type de la marque :", film.types_marques_for_ttyprompt, per_page:film.types_marques_for_ttyprompt.count)
			case type
			when NilClass then return nil
			when :new then type = create_new_type_marque || return
			end
		end

		# 
		# On ajuste les paramètres à renvoyer
		# 
		params[:as_sentence] = "#{type} #{params[:as_sentence]}"
		params[:type] = type

		return params
	end

	# 
	# {String}
	# 
	# Pour créer un nouveau type de marque
	# 
	def create_new_type_marque(mdata = {})
		type 	= mdata[:type] || Q.ask("Type de la marque (pas plus de 6 lettres) :") || return
		label = Q.ask("Label de la nouvelle marque :") || return
		types_marques = film.infos[:types_marques] || {}
		types_marques.merge!(type => label)
		film.save_infos(types_marques: types_marques)
		puts "Nouveau type de marque créé avec succès."
	end

	# 
	# {String}
	# 
	# Retourne le résumé à donner à la nouvelle marque, en le prenant
	# dans les paramètres ou en le demandant s'il n'existe pas.
	# 
	def define_resume_in(params)
		if params[2]
			resume = params[:as_sentence].split(' ')
			resume.shift # le type de marque
			resume = resume.join(' ').strip
			resume = nil if resume.empty?
		end
		resume || Q.ask("Résumé de la marque :")
	end

	# 
	# {Integer}
	# 
	def define_end_time(from_time)
		ask_for_temps_fin("Temps de fin de la marque", from_time)
	end

end #/<< self
end#/class Marque
