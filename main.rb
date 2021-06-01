#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true

require_relative 'lib/required'

AWV.init

while buf = Readline.readline("#{INVITE}", true)
  # p Readline::HISTORY.to_a
  # print("-> ", buf, "\n")

  buf = 'togglePlay' if buf.empty?

  exit 0 if buf == 'quit' || buf == 'exit' || buf == 'q'

  # 
  # On s'assure toujours que les éléments sont à jour, par rapport
  # à la dernière date de relève des données. Cela permet, par 
  # exemple, d'actualiser la liste des scènes ou des personnages
  # lorsqu'elles ont été modifiées "à la main" en cours de collecte.
  # 
  film.check_if_outofdate

  # 
  # On analyse la commande pour en tirer tout ce qu'il faut, à 
  # commencer par le premier mot (word1) qui définit à proprement
  # parler la commande à jouer.
  # 
  word1, params = AWV.parse_command(buf)

  # 
  # On mémorise toujours le temps actuel de la vidéo, qu'on
  # consigne dans VLC.command_time, pour y avoir accès pour certaine
  # commande.
  # 
  VLC.command_time = VLC.current_time.freeze

  # 
  # Arrêt de la lecture si le premier mot termine par "-"
  # 
  reprendre = false
  if word1.end_with?('-')
    word1 = word1[0..-2]
    reprendre = vlc('return playing').strip == 'true'
    VLC.pause
  end

  # 
  # Cas spécial d'une commande à une lettre, pour créer rapidement une
  # scène, une note, etc.
  #
  if word1.length == 1

  	lettre_commande = word1[0]
  	word1 = Commande.exec_lettre_commande(word1[0], params)

  end

  case word1
  when NilClass
    # ne rien faire (la commande a déjà été jouée avant)
  when 'togglePlay'
  	VLC.togglePlay
  when 'stop', 'pause'
  	VLC.stop
  when 'play'
  	VLC.play
  when /^\-[0-9]+$/ # remonter le temps
  	VLC.goto(VLC.current_time - word1[1..-1].to_i)
  when /^\+[0-9]+$/ # avancer dans le temps
  	VLC.goto(word1[1..-1].to_i + VLC.current_time)
  else
    real_command = Commande.require_commande(word1) || next
	  Commande.send(real_command.to_sym, params)
  end


  # 
  # Faut-il reprendre la lecture ?
  # 
  VLC.play if reprendre


end