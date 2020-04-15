class PostReportJob < ApplicationJob
  # aqui se usa la cola por defecto es con thread pool, si se utiliza redis o sidekiq esto se modifica
  queue_as :default

  # para probar PostReportJob.perform_later(User.first.id, Post.first.id)
  def perform(user_id, post_id)
    user = User.find(user_id)
    post = Post.find(post_id)

    # llamar al metodo de la clase PostReport que se encargar de generar el reporte
    report = PostReport.generate(post)

    # enviar el mail, se usa deliver_now porque ya esta dentro de un job, si fuera en otro lado es mejor
    # usar deliver_later, para qeu se encole y se envie
    PostReportMailer.post_report(user, post, report).deliver_now
  end
end
