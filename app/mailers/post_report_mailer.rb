class PostReportMailer < ApplicationMailer
  # se crea un metodo que enviara el mail, este buscara una vista en los mailers folder con el mismo nombre de la clase,
  # que se debe llamar igual al metodo creado
  def post_report(user, post, report)
    @post = post
    mail to: user.email, subject: "Post #{post.id} report"
  end
end
