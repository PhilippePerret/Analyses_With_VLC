# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Test du panneau d'accueil
	--------------------------
	Il est différent en fonction du fait qu'on a ouvert l'application
	récemment ou non

=end
require_relative '_required'

describe 'Le panneau d’accueil' do


  context 'lorsque l’on n’a jamais ouvert l’application' do
  	before :all do
  	  File.delete(AWV.hotdata_file)
  	end
  	it 'présente le panneau intégral' do
  		launch_app
  		accueil = console(100)
  		expect(accueil).to include("BIENVENUE DANS ANALYSES WITH VLC (AWV)")
  		expect(accueil).to include("Cette application permet de collecter et d’analyser")
  		expect(accueil).to include()
  	end
  end
  


  context 'lorsque l’on n’a pas ouvert l’application depuis plus d’une semaine' do
  	before :all do
  		AWV.update_hotdata(last_launched_at: Time.now.to_i - 8.days)
  	end
  	it 'présente le panneau intégral' do
  		launch_app
  		accueil = console(100)
  		expect(accueil).to include("BIENVENUE DANS ANALYSES WITH VLC (AWV)")
  		expect(accueil).to include("Cette application permet de collecter et d’analyser")
  		expect(accueil).to include()
  	end
  end



  context 'lorsque l’on a ouvert l’application la veille' do
  	before :all do
  		AWV.update_hotdata(last_launched_at: Time.now.to_i - (1.day + 1000))
  	end
  	it 'présente la version réduite de la présentation' do
  		launch_app
  		accueil = console(100)
  		expect(accueil).to include("BIENVENUE DANS ANALYSES WITH VLC (AWV)")
  		expect(accueil).not_to include("Cette application permet de collecter et d’analyser")
  	end
  end



  context 'lorsque l’on a ouvert l’application juste avant' do
  	before :all do
  		AWV.update_hotdata(last_launched_at: Time.now.to_i - 1000)
  	end
  	it 'ne s’affiche pas' do
  		launch_app
  		accueil = console(100)
  		expect(accueil).not_to include("BIENVENUE DANS ANALYSES WITH VLC (AWV)")
  		expect(accueil).not_to include("Cette application permet de collecter et d’analyser")
  	end
  end
end