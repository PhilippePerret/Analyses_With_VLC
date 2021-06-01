# encoding: UTF-8
# frozen_string_literal: true
=begin
	Commande 'pfa'
=end
class Commande
class << self
	def pfa(params = nil)
		action = params[1] || choisir_action_pfa || return
		action = DIM_ACTION_TO_REAL[action] || action
		PFA.send(action, params)
	end

	def choisir_action_pfa
		Q.select("Quelle action dois-je accomplir ?") do |q|
			q.choices ACTIONS_PFA
			q.per_page ACTIONS_PFA.count
		end
	end

end #/<< self

ACTIONS_PFA = [
	{name: "Définir un élément du PFA", value: :define_element},
	{name: "Éditer les données du PFA", value: :edit},
	{name:"Constuire un PFA", value: :build},
	{name:"Initier un nouveau PFA", value: :init},
	{name: "Renoncer", value: nil},
]

DIM_ACTION_TO_REAL = {
	'ne' => :define_element
}
end #/Commande