class PostsSearchService
  def self.search(curr_post, query)
    # implementacion de caching, el cache es key value
    # aqui se sacrifica correctitud por desempeño, esto se llama trade-off, una ventaja por una desventaja
    posts_ids = Rails.cache.fetch("post_search/#{query}", expires_in: 1.hours) do
      # no guardar mucho contenido en el cache, en este caso solo guardar los ids
      # retornar los ids, este query solo se hara una vez y sera guardado en cache
      # # https://guides.rubyonrails.org/caching_with_rails.html
      curr_post.where("title like '%#{query}%'").map(&:id)
    end

    # retornar la busqueda
    curr_post.where(id: posts_ids)
  end
end
