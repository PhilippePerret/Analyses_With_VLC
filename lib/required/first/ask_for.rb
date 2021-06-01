# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Méthode de requête

=end

def ask_for(question)
	reponse = Q.ask(question)
	return nil if reponse.nil? || reponse.strip.empty?

	return reponse.strip
end

# 
# Demande un titre
# 
def ask_for_titre(question)
	Q.ask(question.bleu)
end

# 
# Demande une description (multi-lignes)
# 
def ask_for_description(question)
	desc = Q.multiline(question)
	desc = desc.collect{|l|l.strip}.join("\n")
	desc = nil if desc.empty?

	return desc
end


def ask_for_temps_fin(question, from_time)
	puts question.bleu
	VLC.choose_time_after(from_time)
end