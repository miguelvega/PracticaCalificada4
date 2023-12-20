# Edit app/models/moviegoer.rb to look like this:
# Es otro modelo de nuestra  aplicación que representa a los usuarios de la aplicación.
class Moviegoer < ActiveRecord::Base
  # Tiene una asociación has_many :reviews, lo que indica que un usuario puede tener muchas revisiones.
  has_many :reviews # Un Moviegoer puede tener muchas revisiones (Review).
  def self.create_with_omniauth(auth)
    Moviegoer.create!(
      :provider => auth["provider"],
      :uid => auth["uid"],
      :name => auth["info"]["name"]
    )
  end
end
