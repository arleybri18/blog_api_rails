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
        let!(:post) { create(:post) }  #crea una variable y se le asigna lo que esta en el bloque 

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


    describe "POST /posts" do
        let!(:user) { create(:user) } # crear un usuario

        it "should create a post" do
            req_payload = {
                post: {
                    title: "title",
                    content: "content",
                    published: false,
                    user_id: user.id
                }
            }

            post '/posts', params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["id"]).to_not be_nil
            expect(response).to have_http_status(:created)
        end

        it "should return error message on invalid post" do
            req_payload = {
                post: {
                    content: "content",
                    published: false,
                    user_id: user.id
                }
            }

            post '/posts', params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["error"]).to_not be_empty
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end

    describe "PUT /posts/:id" do
        let!(:article) { create(:post) } # crear un post

        it "should update a posts" do
            req_payload = {
                post: {
                    title: "new title",
                    content: "new content",
                    published: true
                }
            }

            put "/posts/#{article.id}", params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["id"]).to eq(article.id)
            expect(payload["title"]).to eq("new title")
            expect(payload["content"]).to eq("new content")
            expect(payload["published"]).to eq(true)
            expect(response).to have_http_status(:ok)
        end

        it "should return an error when update a post" do
            req_payload = {
                post: {
                    title: nil,
                    content: nil,
                    published: true
                }
            }

            put "/posts/#{article.id}", params: req_payload
            payload = JSON.parse(response.body)
            expect(payload).to_not be_empty
            expect(payload["error"]).to_not be_empty
            expect(response).to have_http_status(:unprocessable_entity)
        end
    end

end