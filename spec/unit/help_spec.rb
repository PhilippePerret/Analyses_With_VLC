# encoding: UTF-8
# frozen_string_literal: true


require_relative '_required'


describe 'AIDE DE L’APPLICATION' do
	
	before :all do
		launch_app
	end

	after :all do
		Apercu.close_all
		Typora.close_all
	end

  describe 'Le fichier PDF de l’aide' do
    it 's’ouvre avec la commande “help”' do
    	Apercu.close_all
    	run("help")
    	tell_me_to_activate
    	expect(Apercu.docs_names).to include("Analyses_With_VLC/Manuel/Manuel.pdf")
    end
    it 's’ouvre avec la commande “aide”' do
    	Apercu.close_all
    	run("aide")
    	tell_me_to_activate
    	expect(Apercu.docs_names).to include("Analyses_With_VLC/Manuel/Manuel.pdf")
    end
  end


  describe 'Le fichier Markdown de l’aide' do

  	context 'avec l’options -w/--write' do
	    it 's’ouvre dans l’éditeur de Markdown spécifié' do
	   		Typora.close_all

	   		run("help -w")
	   		expect(Typora.docs_names).to include("Manuel.md")

	   		Typora.close_all
	   		run("help --write")
	   		expect(Typora.docs_names).to include("Manuel.md")

	  	end

	    it 'ne s’ouvre pas dans Aperçu' do
	    	Apercu.close_all
	   		run("help -w")
	   		expect(Apercu.docs_names).not_to include("Manuel.pdf")
	   		run("help --write")
	   		expect(Apercu.docs_names).not_to include("Manuel.pdf")   		
	    end

	  end

  end

end