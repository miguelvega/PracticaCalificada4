# Cada revisión (Review) pertenece a un Movie y a un Moviegoer.
class Review < ActiveRecord::Base
    # Pertenece a un Movie y a un Moviegoer mediante las relaciones belongs_to.
    belongs_to :movie
    belongs_to :moviegoer
end
