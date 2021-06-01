# encoding: UTF-8
# frozen_string_literal: true
=begin
	
	Module de test de la navigation dans le film

=end
require_relative '_required'

describe 'NAVIGATION DANS LE FILM' do
  
  before :all do
  	@params = Preparator.init_with(film: :default)
  	@tfilm = @params[:film]
  end

  before :each do 
    launch_app
  end

  let(:tfilm) { @tfilm }

  it 'la commande “goto” permet de se rendre à un point précis du film' do
  	VLC.set_current_time(10)
  	expect(VLC).to have_current_time(10)
  	run("goto 100")
  	expect(VLC).to have_current_time(100)
  end

  describe 'la commande goto sans paramètres' do
    it 'demande de donner un temps' do
      run("goto")
      expect(console).to include("Quel est le temps (rien pour choisir une scène) ?")
    end
  end
  
  describe 'la commande goto après un premier retour chariot' do

    context 'avec des scènes définies' do
      before do
        @scenes = @tfilm.build_scenes(3)
      end
      it 'permet de rejoindre une scène' do
        run("goto")
        run("")
        sleep 2
        dernieres = console(10)
        @scenes.each do |hscene|
          expect(dernieres).to include(hscene[:r])
        end
      end
    end

    context 'sans scène définies' do
      before do
        @tfilm.erase_scenes
      end
      it 'indique le message d’erreur' do
        run("goto")
        run("")
        sleep 2
        expect(console(2)).to include("Aucune scène à rejoindre")
      end
    end
  
  end

  it 'la commande “+xxx” permet d’avancer de xxx secondes' do
  	VLC.set_current_time(30)
  	expect(VLC).to have_current_time(30)
  	run("+10")
  	expect(VLC).to have_current_time(40)
  end

  it 'la commande "-xxx" permet de reculer de xxx secondes' do
  	VLC.set_current_time(20)
  	expect(VLC).to have_current_time(20)
  	run("-7")
  	expect(VLC).to have_current_time(13)
  end

  describe 'la commande vide', only:true do
    context 'quand la vidéo joue' do
      it 'permet de l’arrêter' do
        VLC.play
        sleep 2
        run("")
        expect(VLC).not_to be_playing
      end
    end
    context 'quand la vidéo est arrêtée' do
      it 'permet de la mettre en route' do
        VLC.stop
        sleep 1
        run("")
        expect(VLC).to be_playing
      end
    end
  end
  
end