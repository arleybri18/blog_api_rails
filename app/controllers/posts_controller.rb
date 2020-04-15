class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update]

    # manejo de excepciones, se debe tener en cuenta el orden de los rescue, cmoienza desde la ultima hasta la primera 
    rescue_from Exception do |e|
        render json: {error: e.message}, status: :internal_error #error 500
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
        render json: {error: e.message}, status: :unprocessable_entity
    end

    def index
        posts = Post.where(published: true)
        if !params[:search].nil? && params[:search].present?
            # Buena practica, crear servicios que se encarguen de la logica
            posts = PostsSearchService.search(posts, params[:search])
        end
        # usando includes se soluciona el N+1 query problem, ya que se incluyen las relaciones, en este caso ya no se hara un query por cada post encontrado, para traer el usuario
        # sino que rails hara otro query, trayendo los users por los ids encontrados en los post, de esta forma solo habran 2 queries, el de post y el de users
        #  SELECT "users".* FROM "users" WHERE "users"."id" IN (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        render json: posts.includes(:user), status: :ok
    end

    def show
        post = Post.find(params[:id])
        if post
            render json: post, status: :ok
        else
            render json: {"msg": "Not found"}, status: 404
        end
    end

    def create
        post = Post.create!(create_params)
        render json: post, status: :created
    end

    def update
        post = Post.find(params[:id])
        post.update!(update_params)
        render json: post, status: :ok
    end

    private
    def create_params
        params.require(:post).permit(:title, :content, :published, :user_id)
    end

    def update_params
        params.require(:post).permit(:title, :content, :published)
    end

    def  authenticate_user!
        token_regex = /Bearer (\w+)/
        # leer headers
        headers = request.headers
        # verificar que el header sea valido
        if headers['Autorization'].present? && headers['Autorization'].match(token_regex)
            token = headers['Autorization'].match(token_regex)[1]
            # validar que el token pertenezca a un usuario
            if(Current.user = User.find_by_auth_token(token))
                return
            end

        end

        render json: {error: 'Unauthorized'}, status: :unauthorized

    end
end