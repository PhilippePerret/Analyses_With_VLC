# encoding: UTF-8
# frozen_string_literal: true
=begin
	Simplement pour essayer
=end
require_relative '_required'

describe 'Lancement de la commande' do
  context 'sans film VLC' do
  	it 'produit une erreur fatale' do
  		launch_app
  		expect(console).to include('Il faut ouvrir un film')
  	end
  end

  context 'avec un film VLC', only:true do
  	before :all do
  	  vlc.open_film(EXTRAIT_FILM_PATH)
  	end
  	it 'se tient prête' do
  		launch_app
  		expect(console(2)).to include(AWV_INVITE)
  	end
  end
end
