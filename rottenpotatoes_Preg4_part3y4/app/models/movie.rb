class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings)
    if ratings.present?
      where('UPPER(rating) IN (?)', ratings.map { |rating| rating.to_s.upcase })
    else 
      all
    end
  end

  validates :title, :presence => true
    validates :release_date, :presence => true
    validate :released_1930_or_later # uses custom validator below
    validates :rating, :inclusion => {:in => Movie.all_ratings},
        :unless => :grandfathered?
    # Se puede usar la linea anterior o la que sigue a continuacion sin la necesidad del metodo de clase all_rattings
    # validates :rating, inclusion: { in: %w[G PG PG-13 R NC-17] }, unless: :grandfathered?

    # Callback antes de guardar la película que capitaliza el título
    before_save :capitalize_title

    # Método de validación personalizado para asegurarse de que la fecha de lanzamiento sea posterior a 1930
    def released_1930_or_later
        errors.add(:release_date, 'must be 1930 or later') if
        release_date && release_date < Date.parse('1 Jan 1930')
    end

    # Variable de clase que representa una fecha de "abuelo" (para grandfathered?)
    @@grandfathered_date = Date.parse('1 Nov 1968')
    
    # Método de instancia que verifica si la película está "abuelada" (para validación de rating)
    def grandfathered?
        release_date && release_date < @@grandfathered_date
    end

    # Callback antes de guardar la película que capitaliza el título
    def capitalize_title
        self.title = self.title.split(/\s+/).map(&:downcase).map(&:capitalize).join(' ')
    end
    
end
