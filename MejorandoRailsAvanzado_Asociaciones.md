# Proceso y Respuestas de la Actividad

Clonamos el respotorio dado en la actividad y nos dirigimos al siguiente directorio de myrottenpotatoes y ejecutamos el comando `bin/rails server` para iniciar nuestro servidor web local que escucha en un puerto específico (por defecto, el puerto 3000), acedemos a nuestra aplicación a través de un navegador web visitando http://localhost:3000, nos muestra un error, ActiveRecord::StatementInvalid nos indica que hay un problema con una consulta SQL en nuestra aplicación Rails.

![2](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/1727abfa-82d2-464c-b6de-af1aba732084)



Por tal motivo al dirigirnos a la terminal nos muestra 500 Internal Server Error que es un código de respuesta de error del servidor que indica que el servidor encontró una condición inesperada que le impidió cumplir con la solicitud debido a que estámos intentando acceder a la tabla moviegoers y Rails no la encuentra en la base de datos. Ademas el error sugiere que el problema está en el método set_current_user ubicado en el archivo Desarrollo-software-2023/Semana7/myrottenpotatoes/app/controllers/application_controller.rb

![3](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/8f7c2696-a34c-4a54-ac31-94209d8b4b09)

Al movernos a la carpeta migrate en el directorio db vemos que tenemos un archivo de migración denominado 20231003234846_create_movies.rb. Escribimos el comando rails generate migration CreateMoviegoers para generar un nuevo archivo de migración en el directorio db/migrate con un esquema básico para crear la tabla moviegoers. El nombre del archivo se generará automáticamente y contendrá una marca de tiempo para garantizar un orden correcto de ejecución de migraciones.

![5](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/19eb9829-b8fa-45ae-915a-f0ad00764e85)

Sin embargo, todavia no hemos ejecutado la migración para aplicar los cambios a la base de datos, para ellos debemos ejecutar el comando `rails db:migrate.

![8](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/9b1910ce-ec48-4641-88e0-b4f774257ae4)

Observamos el archivo schema.rb que contiene información sobre la estructura de la base de datos, incluyendo las tablas y sus columnas. Este archivo se genera automáticamente a partir de las migraciones y refleja el estado actual de la base de datos. Podemos observar en la siguiente imagen que tenemos dos tablas, entre ellas la tabla moviegoer y con ello solucionariamos el error anterior.

![9](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/9ee6796b-d53c-41cd-9d1d-e9c87f84942d)

Ejecutamos el comando bin/rails server nuevamente y notamos un nuevo error, esta vez relacionado a un error de sintaxis en el archivo app/models/movie.rb, esto se puede apreciar en la siguiente imagen.

![10](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/21d333b5-434f-46ed-a9fe-50ef806d38a2)

Lo solucionamos editando el archivo movie.rb, quedandonos de la siguiente manera.

![11](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/9077b67d-c2c6-4d13-9b64-cbd5acc81adc)


Ejecutamos el comando bin/rails server y podemos ver la siguiente vista  a traves de un navegador web, esta vista lo maneja los archivos index.html.haml (representa la vista de la lista de todas las películas), new.html.haml (se utiliza para mostrar el formulario de creación de una nueva película), show.html.haml (.muestra los detalles de una película específica). Estas vistas son componentes esenciales para la interacción del usuario con la aplicación.

![13](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/c0600d41-df01-4b6a-a22c-e09cddbe0297)

Las validaciones en Rails son mecanismos que permiten asegurar que los datos almacenados en la base de datos cumplen con ciertos criterios antes de ser guardados.Si una validación falla, el objeto no se guardará y se agregarán errores al objeto para indicar qué validaciones fallaron y por qué. Estas validaciones ayudan a mantener la integridad, seguridad, la experiencia del usuario, el mantenimiento de las reglas de negocio y la consistencia de los datos en la aplicación.

Por ello, para estudiar este mecanismo editaremos el archivo `movie.rb` con el siguiente codigo:

```
class Movie < ActiveRecord::Base
    def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings
    validates :title, :presence => true
    validates :release_date, :presence => true
    validate :released_1930_or_later # uses custom validator below
    validates :rating, :inclusion => {:in => Movie.all_ratings},
        :unless => :grandfathered?
    def released_1930_or_later
        errors.add(:release_date, 'must be 1930 or later') if
        release_date && release_date < Date.parse('1 Jan 1930')
    end
    @@grandfathered_date = Date.parse('1 Nov 1968')
    def grandfathered?
        release_date && release_date < @@grandfathered_date
    end
end

```
Ejecutamos el comando rails console y comprobamos los resultados creando una nueva instancia de la clase Movie con atributos específicos, incluyendo un título en blanco (''), una clasificación ('RG'), y una fecha de lanzamiento anterior a 1930 ('1929-01-01').

![19](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/45d3b1b9-63f4-4d13-9a4d-3b3cc3fe1e6f)

Entonces, como tenemos un registro no valido, si queremos guardar este registro en la base de datos con m.save no se va a poder. Debido a que las validaciones nos ayuda a prevenir la inserción de datos incorrectos o no válidos en la base de datos. Ademas, si queremos comprobar esto podemos salir de de la consola de la consola de rails con exit y ejecutamos `sqlite3 db/development.sqlite3`, realizamos la consulta `Select * from movies;`  con lo cual podemos ver todas las peliculas presentes en la tabla movies de la base de datos y se puede apreciar que no hay ningun registro nuevo añadido. 

Explica el código siguiente :

```
class MoviesController < ApplicationController
  def new
    @movie = Movie.new
  end 
  def create
    if (@movie = Movie.create(movie_params))
      redirect_to movies_path, :notice => "#{@movie.title} created."
    else
      flash[:alert] = "Movie #{@movie.title} could not be created: " +
        @movie.errors.full_messages.join(",")
      render 'new'
    end
  end
  def edit
    @movie = Movie.find params[:id]
  end
  def update
    @movie = Movie.find params[:id]
    if (@movie.update_attributes(movie_params))
      redirect_to movie_path(@movie), :notice => "#{@movie.title} updated."
    else
      flash[:alert] = "#{@movie.title} could not be updated: " +
        @movie.errors.full_messages.join(",")
      render 'edit'
    end
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path, :notice => "#{@movie.title} deleted."
  end
  private
  def movie_params
    params.require(:movie)
    params[:movie].permit(:title,:rating,:release_date)
  end
end
```
 Este controlador sigue las convenciones de Rails y proporciona las acciones necesarias para realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) en el modelo de películas.

Editamos el archivo movie.rb y comprobamos que el siguiente codigo ilustra cómo utilizar este mecanismo para “canonicalizar” (estandarizar el formato de ciertos campos del modelo antes de guardar el modelo).

```
class Movie < ActiveRecord::Base
    before_save :capitalize_title
    def capitalize_title
        self.title = self.title.split(/\s+/).map(&:downcase).map(&:capitalize).join(' ')
    end
end

```
Con lo cual el metodo `capitalize_title` se encargará de dividir las palabras en el título, convertirlas a minúsculas y luego capitalizar la primera letra de cada palabra antes de unirlas nuevamente. Ejecutamos el comando rails console y comprobamos los resultados creando una nueva instancia de la clase Movie con atributos específicos, incluyendo un título ('STAR wars'), una fecha de lanzamiento ('127-5-1977) y una clasificación ('PG'). Al escribir m.title en la consola deberiamos ver que el título se ha estandarizado y capitalizado como "Star Wars".

![21](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/a15055a8-9fb3-44ea-94c9-709738121e07)

Ejecutamos bin/rails server y podemos apreciar qie se agrego un nuevo registro en la tabla de peliculas.

```
Star Wars 	PG 	1977-05-27 00:00:00 UTC 	More about Star Wars

```

## SSO y autenticación a través de terceros

Una manera de ser más DRY y productivo es evitar implementar funcionalidad que se puede reutilizar a partir de otros servicios. Un ejemplo muy actual de esto es la autenticación.

Afortunadamente, añadir autenticación en las aplicaciones Rails a través de terceros es algo directo. Por supuesto, antes de que permitamos iniciar sesión a un usuario, ¡necesitamos poder representar usuarios! Así que antes de continuar, vamos a crear un modelo y una migración básicos siguiendo las instrucciones.

 Al continuar con la realizacion  de la actividad tenemos las siguiente instruccion `rails generate model Moviegoer name:string provider:string uid:string`, sin embargo hay un conflicto(debido al nombre 'Moviegoer' que ya se utiliza en nuestra aplicación) con el archivo  `db/migrate/20231114214700_create_moviegoers.rb` realizada anteriormente, por ello realicè el comando `rails generate model Moviegoer name:string provider:string uid:string --skip-collision-check --force`, con lo cual el comando remueve el archivo de migración anterior, es decir `20231113195135_create_moviegoers.rb`, crea un nuevo archivo de migración `db/migrate/20231114214754_create_moviegoers.rb` y sobrescribe el archivo del modelo Moviegoer.

 ![25](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/471e7210-7ba0-487c-a6cd-a871ec877174)

 
 
 Para evitar futuros errores o conflictos, eliminamos la base de datos y la creamos nuevamente.

![28](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/57e85776-c0eb-461b-9e9a-76855d3950d4)

Editamos el archivo schema.rb donde se almacena la estructura actual de la base de datos para que se encuentra con la version `2023_10_03_234846`, es decir, previo a la clonacion del repositoio.

![29](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/c2b2947f-cdef-49e8-b223-2e44ee796a51)


Luego, ejecutamos el comando `rails db:migrate` para crear la tabla moviegoeres e incorporarla al archivo y darle la version al schema de esta ultima migracion como se puede apreciar en su marca de tiempo dada en la siguiente imagen.


 ![32](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/d1b51a99-3469-4dc3-a73c-7d39fe963ecb)

 
Sin embargo, la base de datos actual esta vacia debido a que no hemos incorporado las semillas dadas en el archivo seeds.rb.

![31](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/01f8ef61-7af2-4782-8473-a382da8cb60a)

Escribimos `rails db:seed` en la terminal y luego ejecutamos `bin/rails server`

![35](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/f5702fc3-46ae-48c4-a758-3a56968fce25)


Luego, editamos el archivo `app/models/moviegoer.rb`
```
# Edit app/models/moviegoer.rb to look like this:
class Moviegoer < ActiveRecord::Base
    def self.create_with_omniauth(auth)
        Moviegoer.create!(
        :provider => auth["provider"],
        :uid => auth["uid"],
        :name => auth["info"]["name"])
    end
end

```
Este archivo define una clase llamada Moviegoer que hereda de ActiveRecord::Base, lo que implica que se espera que interactúe con una base de datos a través de ActiveRecord. La función principal de este archivo es proporcionar un método llamado self.create_with_omniauth(auth) que se encarga de crear un nuevo registro de Moviegoer utilizando la información de autenticación (auth) proporcionada. Esta función está diseñada para ser utilizada en el contexto de autenticación mediante OmniAuth.


Ademas, se puede autenticar al usuario a través de un tercero. Usaremos la excelente gema OmniAuth que proporciona una API uniforme para muchos proveedores de SSO diferentes. Para ello, agregamos en nuestro archivo Gemfile las siguiente gemas:

```
gem 'omniauth'
gem 'omniauth-twitter'

```
Ejecutamos bundle install para incoporarlas en nuestra aplicacion localmente.


Ahora bien, la mayoría de los proveedores de autenticación requieren que registremos cualquier aplicación que utilizará su sitio para la autenticación, por lo que en este ejemplo necesitaremos crear una cuenta de desarrollador de Twitter.

![36](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/220ce362-a94e-489c-b026-49e4fbdde58e)

Insertamos en el siguiente codigo nuestra API key y API key secret que obtuvimos al registrar tu aplicación en Twitter.
```
# Replace API_KEY and API_SECRET with the values you got from Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "API_KEY", "API_SECRET"
end
```

Agregamos el siguiente codigo en el archivo `config/routes.rb`que nos ayuda a agregar las rutas necesarias para manejar la autenticación:
```
#routes.rb
get  'auth/:provider/callback' => 'sessions#create'
get  'auth/failure' => 'sessions#failure'
get  'auth/twitter', :as => 'login'
post 'logout' => 'sessions#destroy'
```
Por ultimo, creamos un controlador de sesiones (sessions_controller.rb), el cual contiene las acciones esenciales para gestionar la autenticación.
```
class SessionsController < ApplicationController
  # login & logout actions should not require user to be logged in
  skip_before_filter :set_current_user  # check you version
  def create
    auth = request.env["omniauth.auth"]
    user =
      Moviegoer.where(provider: auth["provider"], uid: auth["uid"]) ||
      Moviegoer.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to movies_path
  end
  def destroy
    session.delete(:user_id)
    flash[:notice] = 'Logged out successfully.'
    redirect_to movies_path
  end
end
```


### Pregunta: Debes tener cuidado para evitar crear una vulnerabilidad de seguridad. ¿Qué sucede si un atacante malintencionado crea un envío de formulario que intenta modificar params[:moviegoer][:uid] o params[:moviegoer][:provider] (campos que solo deben modificarse mediante la lógica de autenticación) publicando campos de formulario ocultos denominados params[moviegoer][uid] y así sucesivamente?.

 
Si el atacante malintencionado logra crear un envío de formulario que intenta modificar params[:moviegoer][:uid] o params[:moviegoer][:provider] mediante la inclusión de campos ocultos como params[moviegoer][uid] y similares, podría potencialmente comprometer la seguridad de la aplicación, podría llevar a realizar cambios no autorizados en la información del usuario autenticado, lo cual resulta en el robo de identidad o en la alteración inapropiada de los datos del usuario.
 


## Asociaciones y claves foráneas

Una asociación es una relación lógica entre dos tipos de entidades de una arquitectura software. Por ejemplo, podemos añadir a RottenPotatoes las clases Review (crítica) y Moviegoer (espectador o usuario) para permitir que los usuarios escriban críticas sobre sus películas favoritas; podríamos hacer esto añadiendo una asociación de uno a muchos (one-to-many) entre las críticas y las películas (cada crítica es acerca de una película) y entre críticas y usuarios (cada crítica está escrita por exactamente un usuario).


Explica la siguientes líneas de SQL:

```
SELECT reviews.*
    FROM movies JOIN reviews ON movies.id=reviews.movie_id
    WHERE movies.id = 41;
``` 
La consulta SQL selecciona todas las columnas de la tabla "reviews" que están asociadas a la película con un id igual a 41 en la tabla "movies".


(a): Creamos y aplica esta migración para crear la tabla Reviews. Las claves foraneas del nuevo modelo están relacionadas con las tablas movies y moviegoers existentes por convención sobre la configuración. 

```
# Run 'rails generate migration create_reviews' and then
#   edit db/migrate/*_create_reviews.rb to look like this:
class CreateReviews < ActiveRecord::Migration
    def change
        create_table 'reviews' do |t|
        t.integer    'potatoes'
        t.text       'comments'
        t.references 'moviegoer'
        t.references 'movie'
        end
    end
end
```

b) Coloca este nuevo modelo de revisión en `app/models/review.rb`. 
```
class Review < ActiveRecord::Base
    belongs_to :movie
    belongs_to :moviegoer
end
```

c) Coloca una copia de la siguiente línea en cualquier lugar dentro de la clase Movie Y dentro de la clase `Moviegoer` (idiomáticamente, debería ir justo después de 'class Movie' o 'class Moviegoer'), es decir realiza este cambio de una línea en cada uno de los archivos existentes `movie.rb` y `moviegoer.rb`.

```
has_many :reviews
```

Con lo cual nuestro archivo schema.rb quedara de la siguiente manera :

![36_2](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/31f39643-179f-4b91-a09d-c0b7a997b223)

Tabla moviegoers:
Campos:
- name: Almacena el nombre del moviegoer.
- provider: Utilizado para almacenar información sobre el proveedor de autenticación (por ejemplo, si se utiliza OAuth).
- uid: Identificación única asociada al proveedor de autenticación.
- created_at y updated_at: Registros de tiempo de creación y actualización respectivamente.


Tabla movies:
Campos:
- title: Almacena el título de la película.
- rating: Utilizado para almacenar el rating de la película (por ejemplo, PG-13, R, etc.).
- description: Campo de texto para almacenar la descripción de la película.
- release_date: Almacena la fecha de lanzamiento de la película.
- created_at y updated_at: Registros de tiempo de creación y actualización respectivamente.

Tabla reviews:
Campos:
- potatoes: Un campo entero que representa una puntuación o calificación asignada a la película en la revisión.
- comments: Un campo de texto que almacena los comentarios o reseñas sobre la película.
- moviegoer_id: Clave foránea que referencia al id de un moviegoer que ha realizado la revisión.
- movie_id: Clave foránea que referencia al id de la película que está siendo revisada.
- Índices:
    - index_reviews_on_movie_id: Un índice en la columna movie_id para mejorar la velocidad de las consultas que involucran búsquedas por película.
    - index_reviews_on_moviegoer_id: Un índice en la columna moviegoer_id para mejorar la velocidad de las consultas que involucran búsquedas por moviegoer.

Donde t.index indica que se está creando un índice en la columna especificada, ["movie_id"] especifica la columna para la cual se está creando el índice. En este caso, es la columna movie_id y name: "index_reviews_on_movie_id" asigna un nombre al índice, que en este caso es "index_reviews_on_movie_id". Los nombres de índices son útiles para referenciarlos y gestionarlos posteriormente.


Las relaciones entre las tablas son las siguientes:
La tabla reviews tiene dos claves foráneas: moviegoer_id y movie_id. Estas se asocian con las tablas moviegoers y movies respectivamente.
Un review está asociado a un moviegoer a través de la columna moviegoer_id.
Un review está asociado a una movie a través de la columna movie_id.

Estas relaciones indican que un moviegoer puede tener varias reviews y una review pertenece a un moviegoer. Del mismo modo, una movie puede tener varias reviews y una review pertenece a una movie.

### Observacion : 
La columna llamada id en las tablas se agrega automáticamente como una clave primaria a menos que se indique explícitamente lo contrario.
En el esquema, cada una de las tablas (moviegoers, movies, y reviews) tiene un campo de tipo entero llamado id que sirve como clave primaria de la tabla. Aunque no está explícitamente escrito en nuestro esquema, Rails sigue la convención de nombres y asume que el campo id se utilizará como clave primaria.

Por ejemplo, en la tabla reviews, las columnas moviegoer_id y movie_id se utilizan para establecer relaciones de clave foránea con las tablas moviegoers y movies, respectivamente. Estas relaciones se basan en la convención de que se espera que exista un campo llamado id en las tablas relacionadas (moviegoers y movies) que sirva como clave primaria.

Así que, aunque no está explícitamente mencionado, se asume que cada tabla tiene un campo id que actúa como clave primaria y que se utiliza implícitamente en las relaciones de clave foránea. Esto es parte de las convenciones de Rails para simplificar el desarrollo, pero también puedes personalizar esto mediante migraciones si es necesario.


Despues de realizar la configuracion para trabajar con asociaciones entre modelos (Movie, Moviegoer, y Review) en nuestra aplicacion ejecutamos `rails console`

![37](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/77a41847-5756-44fa-b575-30bce0161488)

Esta línea recuperará la primera película con el título con el título 'Chucky', rating 'G' y fecha de lanzamiento '27-05-1990' si existe, o la crea con esos atributos si no se encuentra ninguna y la asigna a la variable chucky. En ambos casos, chucky contendrá la instancia de la película, ya sea la existente o la recién creada. Las consultas SQL indican las búsquedas y la creación del registro en la tabla movies.

![38](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/8324453d-66a0-4beb-8b05-061b42cbfd4d)

Similar al primer paso, busca en la tabla moviegoers un registro con el nombre 'Miguel', proveedor 'twiter' y UID '1'. Si no lo encuentra, lo crea con esos atributos. En ambos casos, miguel contendrá la instancia del cinefilo , ya sea la existente o la recién creada. Las consultas SQL indican las búsquedas y la creación del registro en la tabla moviegoers. <br>
Analogamente con la segunda linea de codigo

![39](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/92624f0c-0b3e-48d8-b3e2-90c1d33a3513)

Se crean dos nuevas instancias de Review, una para 'Miguel' y otra para 'Aldo', ambas para la película 'Chucky'.
Estas instancias aún no se han guardado en la base de datos. Estamos aprovechando las asociaciones entre los modelos Review, Movie, y Moviegoer, dichas asociaciones permiten que Rails infiera automáticamente las claves foráneas necesarias (movie_id y moviegoer_id) para las relaciones.
La estructura de la tabla reviews tiene columnas moviegoer_id y movie_id, que son claves foráneas. Estas claves foráneas están asociadas con los modelos Moviegoer y Movie, respectivamente. En lugar de proporcionar directamente los valores para moviegoer_id y movie_id, aprovechas las asociaciones para asignar objetos directamente:
- movie: chucky: Rails automáticamente asigna el id de la película chucky a la columna movie_id de la revisión.
- moviegoer: miguel: Rails automáticamente asigna el id de miguel a la columna moviegoer_id de la revisión.

Este enfoque facilita la creación de registros asociados y asegura que las claves foráneas se establezcan correctamente según las asociaciones definidas en los modelos. En resumen, Rails maneja la asignación de las claves foráneas en función de las relaciones entre los modelos, y no es necesario proporcionar directamente los valores de las claves foráneas en este caso.
<br>
Luego, en la siguiente linea asignamos las revisiones (miguel_review y aldo_review) a la película chucky en el modelo de datos y se obrserva lo siguiente:
<br>
Asociación de Objetos:
<br>

- miguel_review y aldo_review son instancias de la clase Review.
- chucky es una instancia de la clase Movie.

<br>

Asignación de Asociaciones:

<br>

- chucky.reviews = [miguel_review, aldo_review] asigna las revisiones a la película chucky.
- La asociación chucky.reviews está definida por la relación de has_many :reviews en el modelo Movie, por ello una pelicula(chucky) puede tener muchas revisiones de distintos usuarios (miguel y aldo).

<br>

Creación de Registros en la Base de Datos:

<br>

- Al asignar las revisiones, Rails reconoce automáticamente las asociaciones y actualiza las columnas movie_id y moviegoer_id en la tabla reviews.
- Se realiza una consulta para cargar las revisiones existentes asociadas con la película chucky.
- Luego, se ejecutan consultas de inserción (INSERT INTO) para agregar las nuevas revisiones (miguel_review y aldo_review) en la tabla reviews.

<br>

Transacción:

<br>

- Todas estas operaciones se realizan dentro de una transacción, lo que significa que se ejecutan como una unidad atómica.
- Si alguna parte de la transacción falla, se revierten todos los cambios.

<br>

Resultado:

<br>

- El resultado que se obtiene ([#<Review:0x00007fbedc35e920 id: 1, potatoes: 4, comments: nil, moviegoer_id: 1, movie_id: 5>,
...]) indica que se han creado con éxito las revisiones asociadas a la película chucky en la base de datos.
- Los IDs y otros atributos de las revisiones se han asignado automáticamente por la base de datos.


![40](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/fb55926f-ba1e-4cba-8724-aad1e4b565cf)

La primera línea agrega la revisión miguel_review a la colección de revisiones asociadas al objeto miguel (instancia de Moviegoer).
Esto establece la relación bidireccional: miguel tiene una revisión asociada y, al mismo tiempo, miguel_review está asociada con miguel.
Similar a la línea anterior, agrega la revisión aldo_review a la colección de revisiones asociadas al objeto aldo (instancia de Moviegoer).
Esto establece la relación bidireccional: aldo tiene una revisión asociada y, al mismo tiempo, aldo_review está asociada con aldo.
En la ultima linea, se obtiene los nombres de los Moviegoers que han revisado la película 'Chucky', chucky.reviews devuelve la colección de revisiones asociadas a la película chucky y al ejecutar map {|r| r.moviegoer.name} se itera sobre estas revisiones y obtiene los nombres de los Moviegoers asociados a cada revisión. 
En resumen, estas líneas de código están trabajando con las asociaciones entre Moviegoer y Review. Están agregando revisiones a las colecciones de revisiones asociadas a los Moviegoers miguel y aldo, y luego recuperan los nombres de los Moviegoers que han revisado la película 'Chucky'.

Este código demuestra el uso de asociaciones y relaciones entre modelos en Rails para representar la relación entre películas, espectadores (usuarios) y revisiones.



```
# it would be nice if we could do this:
chucky = Movie.where(title: 'Chucky', rating: 'G', release_date:'27-05-1990').first_or_create
miguel = Moviegoer.find_by(name: 'Miguel', provider: 'twiter', uid: '1') || Moviegoer.create(name: 'Miguel', provider: 'twiter', uid: '1')
aldo = Moviegoer.find_by(name: 'Aldo', provider: 'twiter', uid: '2') || Moviegoer.create(name: 'Aldo', provider: 'twiter', uid: '2')
# Miguel likes Chucky, Aldo less so
miguel_review = Review.new(potatoes: 4, movie: chucky, moviegoer: miguel)
aldo_review = Review.new(potatoes: 2, movie: chucky, moviegoer: aldo)
# a movie has many reviews:
chucky.reviews = [miguel_review, aldo_review]
# a moviegoer has many reviews:
miguel.reviews << miguel_review
aldo.reviews << aldo_review
# can we find out who wrote each review?
chucky.reviews.map { |r| r.moviegoer.name } # => ['miguel','aldo']
```


Ejecutamos el comando `sqlite3 db/development.sqlite3`  y mostramos los registros y relaciones presentes que existen en las tablas de nuestra base de datos

![42](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/d3f37365-3567-4987-91d1-ec37b7beca8e)


## Asociaciones indirectas

Volviendo a la figura siguiente, vemos asociaciones directas entre Moviegoers y Reviews, así como entre Movies y Reviews.

![41](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/9e9243ae-8ced-4dcc-bc26-29ea69ee5620)

### Moviegoer (1) --- (0..*) Review:
- Un Moviegoer tiene la posibilidad de tener ninguna o varias Review.
- Una Review debe pertenecer a un Moviegoer (es decir, tiene una relación obligatoria con un Moviegoer), pero un Moviegoer puede no tener ninguna Review (relación opcional).

### Review (0..*) --- (1) Movie:
- Un Review debe pertenecer a una Movie (es decir, tiene una relación obligatoria con una Movie), pero un Movie puede no tener ninguna Review (relación opcional).
- Una Movie tiene la posibilidad de estar relacionada con ninguna o varias Review.

Ejecutamos el comando `sqlite3 db/development.sqlite3`  y mostramos los registros y relaciones presentes que existen en las tablas de nuestra base de datos

![42](https://github.com/miguelvega/Rails-Avanzado/assets/124398378/d3f37365-3567-4987-91d1-ec37b7beca8e)


¿Qué indica el siguiente código SQL ?

```
SELECT movies .*
    FROM movies JOIN reviews ON movies.id = reviews.movie_id
    JOIN moviegoers ON moviegoers.id = reviews.moviegoer_id
    WHERE moviegoers.id = 1;
```

La consulta selecciona y devuelve todas las columnas de la tabla movies para aquellas películas que tienen revisiones asociadas realizadas por un moviegoer específico con un id igual a 1. En esta consulta el campo moviegoer_id de la tabla reviews sirve como puente de enlace entre las tablas movies y la tabla moviegoer para poder realizar esta consulta. Con lo cual si hay dos tablas que no se conectan pero deseas hacer una consultas que involucren campos de dichas tablas, entonces una solucion seria usar una tabla intermediaria de tal modo que tenga campos que se relacionen con dichas tablas. 

