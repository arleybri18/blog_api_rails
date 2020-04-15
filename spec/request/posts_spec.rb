require 'rails_helper'
require 'byebug'

RSpec.describe 'Post', type: :request do

    describe 'GET /posts' do # los describe proveen contexto

        it 'should return OK' do
            get '/posts'
            payload = JSON.parse(response.body)
            expect(payload).to be_empty
            expect(response).to have_http_status(200)
        end

        describe 'search' do
          let!(:hola_mundo) { create(:published_post, title: 'Hola Mundo')}
          let!(:hola_rails) { create(:published_post, title: 'Hola Rails')}
          let!(:curso_rails) { create(:published_post, title: 'Curso Rails')}

          it 'Should filter posts by title' do
            get "/posts?search=Hola"
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload.size).to eq(2)
            expect(payload.map {|p|  p['id']}.sort).to eq([hola_mundo.id, hola_rails.id].sort)
            expect(response).to have_http_status(200)
          end
        end

    end

    describe "With data in db" do
        #factory bot
        let!(:post) { create_list(:post, 10, published: true) }  #crea una variable y se le asigna lo que esta en el bloque 
        # let   modo lazy, solo se evaluara hasta que se haga referencia a la variable, line 26
        # let! modo eagerly, permite que se creen los posts desde antes, sin tener que esperar a que se haga referencia a la variable

        it 'should return all post published' do
            get '/posts'
            payload = JSON.parse(response.body)
            expect(payload.size).to eq(post.size)
            expect(response).to have_http_status(200)            
        end
    end

    describe 'GET /posts/:id' do
        #factory bot
        let!(:post) { create(:post, published: true)}  #crea una variable y se le asigna lo que esta en el bloque

        it 'should return one post' do
            get "/posts/#{post.id}" # se utiliza la variable post creada por factory bot
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["id"]).to eq(post.id)
            expect(payload["title"]).to eq(post.title)
            expect(payload["content"]).to eq(post.content)
            expect(payload["published"]).to eq(post.published)
            expect(payload["author"]["name"]).to eq(post.user.name)
            expect(payload["author"]["email"]).to eq(post.user.email)
            expect(payload["author"]["id"]).to eq(post.user.id)
            expect(response).to have_http_status(200)            
        end
    end
end