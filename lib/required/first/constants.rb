# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Constantes

=end
require_relative 'Config'

class AWVSystemError < StandardError; end

AWV_INVITE = "🎞" # utile aux tests aussi
INVITE = "#{AWV_INVITE}  "

YAML_EDITOR = Config[:yaml_editor]

# 
# Les options en version courte
# 
OPTIONS_SHORT_TO_LONG = {
	dev: 	:development,
	q: 		:quiet,
	v: 		:verbose,
	w: 		:write,
}

# 
# Les commandes alternatives
# 
ALT_COMMAND_TO_REAL = {
	'aide' => 'help'
}