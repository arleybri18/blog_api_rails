class PostReport < Struct.new(:word_count, :word_histogram)
  def self.generate(post)
    PostReport.new(
        #word_count
        post.content.split.map { |word| word.gsub(/\W/, '') }.count, # debe ir esta coma al final
        # word_histogram
    calc_histogram(post)
    )
  end

  private
  def self.calc_histogram(post)
    post.content
        .split #parte por espacios
        .map { |word| word.gsub(/\W/, '') } # elimina caracteres deja solo palabras
        .map(&:downcase) # pasa a un array de las palabras en minuscula
        .group_by { |word|  word} # agrupa por palabra {word => [word, word]}
        .transform_values(&:size) # transforma los valores por el tamaño del array {word => 2}
  end
end
