# Proceso y Respuestas

## Preguntas

## 2. Practiquemos la herencia y la programación orientada a objetos en Javascript. Diseña 2 clases, una llamada "Pokemon" y otra llamada "Charizard". Las clases deben hacer lo siguiente:

Clase Pokémon: <br>
• El constructor toma 3 parámetros (HP, ataque, defensa) <br>
• El constructor debe crear 6 campos (HP, ataque, defensa, movimiento, nivel, tipo). Los valores de (mover, nivelar, tipo) debe inicializarse en ("", 1, ""). <br>
• Implementa un método flight que arroje un error que indique que no se especifica ningún movimiento. <br>
• Implementa un método canFly que verifica si se especifica un tipo. Si no, arroja un error. Si es así, verifica si el tipo incluye ‘’flying’. En caso afirmativo, devuelve verdadero; si no, devuelve falso.<br>

El codigo que cumple dichas especificaciones seria el siguiente para la clase Pokemon:

```javascript
class Pokemon {
    constructor(HP, ataque, defensa) {
      this.HP = HP;
      this.ataque = ataque;
      this.defensa = defensa;
      this.movimiento = "";
      this.nivel = 1;
      this.tipo = "";
  
      // Método flight
      this.flight = function () {
        throw new Error("No se especificó ningún movimiento.");
      };
  
      
      this.canFly = function () {
        if (!this.tipo) {
          throw new Error("No se especificó ningún tipo.");
        }
        return this.tipo.includes("volar");
      };
    }
  }

```
Ahora vamos a implementa la Clase Charizard con las siguientes especificaciones:
• El constructor toma 4 parámetros (HP, ataque, defensa, movimiento). <br>
• El constructor configura el movimiento y el tipo (para "disparar/volar") además de establecer HP, ataque y defensa como el constructor de superclase. <br>
• Sobreescribe el método fight . Si se especifica un movimiento, imprime una declaración que indique que se está utilizando el movimiento y devuelve el campo de ataque. Si no arroja un error.  (implementa utilizando JavaScript ). <>br 

El codigo que cumple con dichas especificaciones seria el siguiente para la clase Charizard:

```javascript

  class Charizard extends Pokemon {
    constructor(HP, ataque, defensa, movimiento) {
      super(HP, ataque, defensa);
      this.movimiento = movimiento;
      this.tipo = "disparar/volar";
    }
  
    // Sobrescribe el método fight
    fight() {
      if (this.movimiento) {
        console.log(`Utilizando el movimiento: ${this.movimiento}`);
        return this.ataque;
      } else {
        throw new Error("No se especificó ningún movimiento.");
      }
    }
  }

```

## 3. El principio de inversión de dependencia establece que los módulos de alto nivel no deberían depender de los módulos de bajo nivel, y tanto los módulos de alto nivel como los de bajo nivel deberían depender de abstracciones. También establece que las abstracciones no deberían depender de implementaciones concretas, sino que las implementaciones concretas deberían depender de abstracciones.

```ruby
class CurrentDay
    def initialize
      @date = Date.today
      @schedule = MonthlySchedule.new(@date.year,@date.month)
    end
    def work_hours
      @schedule.work_hours_for(@date)
    end
    def workday?
      !@schedule.holidays.include?(@date)
    end
end

```

### ¿Cuál es el problema con este enfoque dado, cuando quieres probar el metodo workday?. 

Probar la clase CurrentDay se vuelve difícil con este enfoque, ya que si queremos probar el método worday? al realizar la prueba durante un día laboral, siempre será verdadero,  y si realizamos la prueba fuera de un día laboral, siempre será falso.
Una forma de solucionar este problema sin cambiar el codigo seria anular la fecha de hoy, es decir Date.today.

Utiliza la inyección de dependencia aplicado al siguiente código.

```ruby

before do
    Date.singleton_class.class_eval do
        alias_method :_today, :today
        define_method(:today){Date.new(2020, 12, 16)}
    end
end
after do
    Date.singleton_class.class_eval do
        alias_method :today, :_today
        remove_method :_today
    end	
end

```

###  ¿Qué sucede en JavaScript con el DIP en este ejemplo? 

Sabemos que en JavaScript utiliza prototipos que permiten a los objetos heredar propiedades y métodos de otros objetos a través de su cadena de prototipos. Donde cada objeto tiene una propiedad privada que mantiene un enlace a otro objeto llamado su prototipo. Ese objeto prototipo tiene su propio prototipo, y así sucesivamente hasta que se alcanza un objeto cuyo prototipo es null. Ahora bien en este ejemplo al tener esta particularidad se tendria que pasar la dependecias mediante metodos mantiendo un enlace al realizar la prueba durante un día laboral.

Los ejercicios a partir de aquí se recomiendan hacerlos en orden.
## Pregunta 2: (Para responder esta pregunta utiliza el repositorio y las actividades que has desarrollado de Introducción a Rails). Modifique la lista de películas de la siguiente manera. Cada modificación va a necesitar que realice un cambio en una capa de abstracción diferente

### a. Modifica la vista Index para incluir el número de fila de cada fila en la tabla de películas.

Necesitamos incorporar algunas líneas de código en nuestra vista  index.html.erb. En primer lugar en la sección de encabezado de la tabla agregamos una nueva columna con `<th>Nro</th>` . Con este cambio, la fila de encabezado de nuestra tabla constará de cinco columnas, como se muestra en el siguiente fragmento de código.

``` ruby
<thead>
    <tr>
      <th>Nro</th>
      <th class="<%=@title_header_class%>" ><%= link_to "Movie Title", movies_path(sort: 'title', direction: toggle_direction('title'), ratings: hash_ratings(@ratings_to_show)), id: 'title_header' %></th>
      <th>Rating</th>
      <th class="<%=@release_date_header_class%>" ><%= link_to "Release Date", movies_path(sort: 'release_date', direction: toggle_direction('release_date'), ratings: hash_ratings(@ratings_to_show)), id: 'release_date_header' %></th>
      <th>More Info</th>
    </tr>
  </thead>
```

Luego, en la parte del cuerpo `<tbody>` de la tabla HTML vamos recorrer la colección de películas (@movies) y generar las filas de datos correspondientes, pero esta vez enumerando las peliculas con `<%= movie.id %> que imprime el ID de la película en la celda correspondiente esto debido a  `<td>`. Quedando el fragmento de codigo de la siguiente manera:

```ruby
<tbody>
    <% @movies.each do |movie| %>
      <tr>
        <td>
         <%= movie.id %>
        </td>
        <td>
          <%= movie.title %>
        </td>
        <td>
          <%= movie.rating %>
        </td>
        <td>
          <%= movie.release_date %>
        </td>
        <td>
          <%= link_to "More about #{movie.title}", movie_path(movie) %>
        </td>
      </tr>
    <% end %>
  </tbody>
```
Ejecutamos rails server y nos muestra lo siguiente en el navegador :

![Captura de pantalla de 2023-12-17 15-00-45](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/a5ac9f7b-7c34-4f56-b28b-47077c592f7c)

### b. Modifica la vista Index para que cuando se sitúe el ratón sobre una fila de la tabla, dicha fila cambie temporalmente su color de fondo a amarillo u otro color.

Reemplazamos el uso de `<tr>` con `<%= content_tag :tr, class: 'row-hover', onmouseover: "this.style.backgroundColor='#FFFF00'", onmouseout: "this.style.backgroundColor=''" do %>`. Al emplear `content_tag`, tenemos la capacidad de añadir una clase `('row-hover')` que está vinculada a estilos CSS específicos, encargados de gestionar la apariencia de las filas cuando el cursor se sitúa sobre ellas. Además, hemos incorporado eventos de JavaScript (`onmouseover` y `onmouseout`) directamente en la definición de la etiqueta `<tr>`. Donde el evento `onmouseover` se activa cuando el puntero del mouse entra en el área de un elemento HTML y cambiara el color de fondo de una fila correspondiente a ese elemento de la tabla. En este caso el color se realiza mediante la instruccion `this.style.backgroundColor='#FFFF00'`, que establece el color de fondo en amarillo `(#FFFF00)`. Ahora bien, `onmouseout` hace la misma tarea pero cuando el mouse sale del elemento, por tal motivo lo utilizamos para revertir el cambio provocado por onmouseover. Quedando el codigo del cuerpo de la tabla de la siguiente manera:

```ruby
<tbody>
    <% @movies.each do |movie| %>
      <%= content_tag :tr, class: 'row-hover', onmouseover: "this.style.backgroundColor='#FFFF00'", onmouseout: "this.style.backgroundColor=''" do %>
        <td>
         <%= movie.id %>
        </td>
        <td>
          <%= movie.title %>
        </td>
        <td>
          <%= movie.rating %>
        </td>
        <td>
          <%= movie.release_date %>
        </td>
        <td>
          <%= link_to "More about #{movie.title}", movie_path(movie) %>
        </td>
      <% end %>
    <% end %>
  </tbody>

```
Ejecutamos rails server y vemos los cambios realizados:

![Captura de pantalla de 2023-12-17 16-53-19](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/f3f18199-46f6-47de-9ae5-b30c4c58d3e5)

### c. Modifica la acción Index del controlador para que devuelva las películas ordenadas alfabéticamente por título, en vez de por fecha de lanzamiento. No intentes ordenar el resultado de la llamada que hace el controlador a la base de datos. Los gestores de bases de datos ofrecen formas para especificar el orden en que se quiere una lista de resultados y, gracias al fuerte acoplamiento entre ActiveRecord y el sistema gestor de bases de datos (RDBMS) que hay debajo, los métodos find y all de la biblioteca de ActiveRecord en Rails ofrece una manera de pedirle al RDBMS que haga esto.

```ruby
if params[:sort].present?
  column_select = sort_column
  direction_select = params[:direction]
  if Movie.column_names.include?(params[:sort]) && ["asc", "desc"].include?(params[:direction])
    @movies = @movies.order("#{column_select} #{direction_select}")
  end
  set_style_header column_select
end

```
Explicamos el codigo : 

- if params[:sort].present?: Verifica si se ha proporcionado un parámetro de ordenación (sort) en la solicitud.

- column_select = sort_column: Utiliza el método privado sort_column para determinar la columna por la cual se ordenarán las películas. Este método verifica si la columna proporcionada es válida y devuelve la columna o una cadena vacía si no es válida.

- direction_select = params[:direction]: Obtiene la dirección de ordenación (ascendente o descendente) proporcionada en los parámetros de la solicitud.

- if Movie.column_names.include?(params[:sort]) && ["asc", "desc"].include?(params[:direction]): Verifica si la columna proporcionada es una columna válida y si la dirección proporcionada es válida.

- @movies = @movies.order("#{column_select} #{direction_select}"): Si todas las condiciones son verdaderas, utiliza el método order para ordenar las películas según la columna y dirección especificadas.

La ordenación está siendo manejada por el sistema gestor de bases de datos a través de la llamada @movies.order("#{column_select} #{direction_select}"), donde column_select se establece en la columna correspondiente (por ejemplo, 'title' si se ordena por título) para ordenar alfabéticamente por título cuando se proporciona un parámetro de ordenación válido (sort: 'title'). Esto se logra mediante el uso del método order de ActiveRecord. Entonces, no estamos intentando ordenar el resultado de la llamada a la base de datos en Ruby. En cambio, estás utilizando la funcionalidad integrada de ordenación proporcionada por ActiveRecord y el sistema gestor de bases de datos. Ademas, en nuestra acción index, estamos utilizando el método with_ratings para filtrar las películas y el método order para ordenarlas, ambos métodos de ActiveRecord que interactúan directamente con el RDBMS.

Con si ejecutamos rails server y si tenemos la siguiente url :
```
http://localhost:3000/movies?direction=asc&ratings%5BG%5D=1&ratings%5BPG%5D=1&ratings%5BPG-13%5D=1&ratings%5BR%5D=1&sort=title
```
Veremos la lista de peliculas ordenada ascendentemente por titulo.

![Captura de pantalla de 2023-12-17 20-28-35](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/9a130875-e1f2-403a-b278-da813584e706)



### Simula que no dispones de ese fuerte acoplamiento de ActiveRecord, y que no puedes asumir que el sistema de almacenamiento que hay por debajo pueda devolver la colección de ítems en un orden determinado. Modifique la acción Index del controlador para que devuelva las películas ordenadas alfabéticamente por título. Utiliza el método sort del módulo Enumerable de Ruby.


```ruby
 if Movie.column_names.include?(params[:sort]) && ["asc", "desc"].include?(params[:direction])
        #@movies = @movies.order("#{column_select} #{direction_select}")
         # Utilizamos el método sort del módulo Enumerable para ordenar alfabéticamente por título
         @movies = @movies.sort_by { |movie| movie.send(column_select) }
         @movies = @movies.reverse if direction_select == 'desc'
  end

```

En este código, he reemplazado la parte de @movies = @movies.order("#{column_select} #{direction_select}") con @movies = @movies.sort_by { |movie| movie.send(column_select) } para utilizar el método sort_by del módulo Enumerable para ordenar la colección @movies según el valor de la columna especificada en column_select. Por ejemplo, si column_select es 'title', entonces movie.send(column_select) sería equivalente a movie.title. En otras palabras, la expresión { |movie| movie.send(column_select) } es un bloque que se ejecuta para cada elemento en @movies. En este bloque, se utiliza movie.send(column_select) para obtener el valor de la columna especificada dinámicamente para cada película. Después de ejecutar este bloque para cada película, el método sort_by ordena la colección en función de esos valores. La línea @movies = @movies.reverse if direction_select == 'desc' se encarga de invertir el orden si la dirección es 'desc', ya que cuando la ordenación es ascendente, utilizamos sort_by para ordenar las películas en orden alfabético, pero si la dirección es 'desc', necesitamos invertir el orden después de la ordenación para que las películas aparezcan en orden descendente.

<br>

order en ActiveRecord (en el contexto de bases de datos):

- Uso: Se utiliza para ordenar los resultados de una consulta a la base de datos.
- Cómo funciona: La ordenación se delega al sistema de gestión de bases de datos (DBMS), que realiza la ordenación directamente en la base de datos antes de devolver los resultados.
- Consideraciones: Muy eficiente para grandes conjuntos de datos, ya que la ordenación se realiza a nivel de la base de datos.

<br>
sort_by en Ruby (en el contexto de colecciones de objetos):

- Uso: Se utiliza para ordenar una colección de objetos en memoria.
- Cómo funciona: Se proporciona un bloque que define el criterio de ordenación. Cada elemento de la colección se evalúa según este bloque y se ordena en consecuencia.
-Consideraciones: Útil cuando deseas ordenar en función de un atributo específico o una lógica personalizada. Menos eficiente que order para grandes conjuntos de datos.

<br>
reverse en Ruby (en el contexto de colecciones de objetos):

- Uso: Se utiliza para invertir el orden de los elementos en una colección.
- Cómo funciona: Simplemente invierte el orden de los elementos, de modo que el primero se convierte en el último y viceversa.
- Consideraciones: Útil después de aplicar una ordenación si deseas cambiar el orden de ascendente a descendente o viceversa.

<br>
En resumen, order es específico de ActiveRecord y se utiliza para ordenar resultados de bases de datos, mientras que sort_by y reverse son métodos de Ruby que se utilizan para ordenar y revertir el orden de colecciones en memoria. Estos últimos son más flexibles pero menos eficientes para grandes conjuntos de datos que requieren ordenación.

<br>

![Captura de pantalla de 2023-12-18 01-13-43](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/eb2fab40-750d-4e39-a8fa-45790820ca14)



## Pregunta 3: (para responder esta pregunta utiliza el repositorio y las actividades que has realizado de Rails avanzado, en particular asociaciones) - 2 puntos

### 1. Extienda el código del controlador del código siguiente dado con los métodos edit y update para las críticas. Usa un filtro de controlador para asegurarte de que un usuario sólo puede editar o actualizar sus propias críticas. Revisa el código dado en la evaluación y actualiza tus repositorios de actividades (no se admite nada nuevo aquí). Debes mostrar los resultados. 

    
## Preguntas 4: (estas preguntas son utilizando el repositorio de todas tus actividades relacionada a JavaScript, por lo tanto, no hay respuestas únicas) - 6 puntos


### 1. Un inconveniente de la herencia de prototipos es que todos los atributos (propiedades) de los objetos son públicos. Sin embargo, podemos aprovechar las clausuras para obtener atributos privados. Crea un sencillo constructor para los objetos User que acepte un nombre de usuario y una contraseña, y proporcione un método checkPassword que indique si la contraseña proporcionada es correcta, pero que deniegue la inspección de la contraseña en sí. Esta expresión de “sólo métodos de acceso” se usa ampliamente en jQuery. Sugerencia:  El constructor debe devolver un objeto en el que una de sus propiedades es una función que aprovecha las clausuras de JavaScript para ‘recordar’ la contraseña proporcionada inicialmente al constructor. El objeto devuelto no debería tener ninguna propiedad que contenga la contraseña).

```javascript
function User(username, password) {
  // Objeto que se devolverá
  var userObject = {};

  // Función interna que aprovecha las clausuras para recordar la contraseña
  function checkPassword(inputPassword) {
    // Compara la contraseña proporcionada con la almacenada
    return inputPassword === password;
  }

  // Agregar la función checkPassword al objeto retornado
  userObject.checkPassword = checkPassword;

  // Otras propiedades y métodos públicos si es necesario
  userObject.getUsername = function () {
    return username;
  };

  // Devolver el objeto con la función checkPassword
  return userObject;
}

// Crear un usuario
var myUser = User("miguel", "miContraseña");

// Intentar acceder a la contraseña directamente generará un error
try {
  console.log(myUser.password);
} catch (error) {
  console.error(error.message); // Salida: Cannot read property 'password' of undefined
}

// Comprobar la contraseña utilizando el método checkPassword
console.log(myUser.checkPassword("contraseñaIncorrecta")); // Salida: false
console.log(myUser.checkPassword("miContraseña")); // Salida: true

// Acceder al nombre de usuario
console.log(myUser.getUsername()); // Salida: miguel


```
Explicaremos el codigo : 

Definición del constructor User:
- Se define una función llamada User que acepta dos parámetros: username y password.
- Esta función actuará como un constructor para crear objetos User.

Creación del objeto userObject:
- Se crea un objeto vacío llamado userObject que será devuelto al final del constructor.

Función interna checkPassword:
- Se define una función interna llamada checkPassword dentro del constructor.
- Esta función utiliza una clausura para acceder a la variable password del ámbito del constructor.

Agregar la función checkPassword al objeto retornado:
- La función checkPassword se agrega como un método llamado checkPassword al objeto userObject. Este método permite comprobar si una contraseña proporcionada es igual a la contraseña almacenada.

Otras propiedades y métodos públicos:
- Se agrega un método llamado getUsername al objeto userObject, que devuelve el nombre de usuario (username).
- En este caso, el único atributo público es el nombre de usuario.

Devolver el objeto userObject:
- El constructor devuelve el objeto userObject que tiene las funciones checkPassword y getUsername, así como las variables privadas username y password gracias a las clausuras.

Crear un usuario:
- Se crea un usuario llamado myUser invocando el constructor User con el nombre de usuario "miguel" y la contraseña "miContraseña".

Intentar acceder a la contraseña directamente:
- Se intenta acceder directamente a la propiedad password de myUser, lo cual generará un error ya que password es privado.

Comprobar la contraseña utilizando el método checkPassword:
- Se utiliza el método checkPassword para comprobar si la contraseña proporcionada es correcta.
- Se imprime en la consola el resultado de las comparaciones.

Acceder al nombre de usuario:

- Se utiliza el método getUsername para obtener y mostrar el nombre de usuario. En este caso, se imprimirá "miguel"

En resumen, este código presenta un constructor de objetos User que emplea clausuras para salvaguardar la privacidad de la contraseña. La función interna checkPassword accede a la variable password gracias a las clausuras. Este método se encarga de comparar la contraseña proporcionada con la almacenada , devolviendo true si son idénticas y false en caso contrario. Además, se ha implementado la recomendación de restringir el acceso directo a la contraseña, de manera que cualquier intento de acceder a myUser.password resultará en un error.
La utilización de clausuras también es destacable, ya que permite recordar la contraseña. La función interna checkPassword retiene la contraseña inicialmente proporcionada al constructor gracias a las clausuras. Este enfoque asegura la integridad de la información y contribuye a la privacidad de los datos del usuario.

Ejecutamos y vemos losm resultados:

![Captura de pantalla de 2023-12-20 23-18-00](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/636c2a49-e19b-41c3-9309-ba2e80ccf0c4)


### 2. Extienda la función de validación en ActiveModel  para generar automáticamente código JavaScript que valide las entradas del formulario antes de que sea enviado. Por ejemplo, puesto que el modelo Movie de RottenPotatoes requiere que el título de cada película sea distinto de la cadena vacía, el código JavaScript deberías evitar que el formulario “Add New Movie” se enviara si no se cumplen los criterios de validación, mostrar un mensaje de ayuda al usuario, y resaltar el(los) campo(s) del formulario que ocasionaron los problemas de validación. Gestiona, al menos, las validaciones integradas, como que los títulos sean distintos de cadena vacía, que las longitudes máximas y mínima de la cadena de caracteres sean correctas, que los valores numéricos estén dentro de los límites de los rangos, y para puntos adicionales, realiza las validaciones basándose en expresiones regulares.

En primera instancia veamos con se encuentra nuestra vista new.html.erb util para que el usuario interactue con nuestra apliaccion y pueda añadir una nueva pelicula 

```
<h2>Create New Movie</h2>

<%= form_tag movies_path, :class => 'form' do %>
  <%= label :movie, :title, 'Title', :class => 'col-form-label' %>
  <%= text_field :movie, :title, :class => 'form-control' %>
  <%= label :movie, :rating, 'Rating', :class => 'col-form-label'  %>
  <%= select :movie, :rating, ['G','PG','PG-13','R'], {}, {:class => 'form-control col-1'} %>
  <%= label :movie, :release_date, 'Released On', :class => 'col-form-label'  %>
  <%= date_select :movie, :release_date, {}, :class => 'form-control col-2 d-inline' %>
  <br/>
  <%= submit_tag 'Save Changes', :class => 'btn btn-primary' %>
  <%= link_to 'Cancel', movies_path, :class => 'btn btn-secondary' %>
<% end %>

```
Cuando se utiliza el helper text_field en Rails, se crea un campo de entrada con un identificador (id) basado en el nombre del modelo y el atributo. En este caso, el modelo es :movie y el atributo es :title, por lo que el identificador se convierte en movie_title. La elección de movie_title en este contexto se basa en la convención utilizada en el formulario HTML.


Ahora, estudiemos la parte principal de la estructura de árbol en el DOM de la vista new , que se podría representar de la siguiente manera:

```
Document
└── <html>
    └── <head>

    └── <body>
        └── <h2>Create New Movie</h2>
        └── <form class="form">
            └── <label for="movie_title" class="col-form-label">
            └── <input id="movie_title" class="form-control" name="movie[title]" type="text">
            └── <label for="movie_rating" class="col-form-label">
            └── <select id="movie_rating" class="form-control col-1" name="movie[rating]">
            └── <label for="movie_release_date" class="col-form-label">
            └── <select id="movie_release_date" class="form-control col-2 d-inline" name="movie[release_date(1i)]">
            └── <br>
            └── <input type="submit" value="Save Changes" class="btn btn-primary">
            └── <a href="/movies" class="btn btn-secondary">
 

```
Esto representa la jerarquía de nodos en el DOM. Cada elemento HTML y sus atributos se convierten en nodos en este árbol. Los nodos secundarios están indentados para mostrar su relación con sus nodos primarios. En este caso, podemos ver cómo los elementos `<form>`, `<label>`, `<input>`, `<select>`, `<br>`, `<input>` y `<a>`están anidados dentro de otros elementos según su posición en el código fuente.

El DOM "ve" el resultado HTML que se renderiza en el navegador, ya sea que haya sido generado estáticamente en el código fuente original o de manera dinámica mediante el procesamiento en el servidor con Ruby on Rails. En última instancia, el navegador trabaja con la representación final del DOM, sin conocer los detalles de cómo se generó. Por ejemplo:

En el HTML sin Ruby on Rails:

```
<input class="form-control" id="movie_title" name="movie[title]" type="text" />

```

Este código HTML es estático y puede escribirse directamente en un archivo HTML. Es la representación que verías si inspeccionas el código fuente de la página web en el navegador con Ctrl+U. Entonces, cuando usamos la extensión .html para un archivo en un proyecto de Ruby on Rails, estamos indicando que el contenido es HTML estático, sin ninguna incrustación de código Ruby. Este tipo de archivo se interpreta como HTML puro y no permite la ejecución de código Ruby en el contexto del archivo. Es adecuado para páginas que no requieren lógica dinámica y cuyo contenido es fijo.

Usando Ruby on Rails

```ruby

<%= text_field :movie, :title, :class => 'form-control' %>

```

Esta línea de código Ruby on Rails se procesa en el servidor antes de enviar la respuesta al cliente. El código Ruby on Rails genera dinámicamente el HTML necesario para el formulario. Cuando el navegador recibe la respuesta del servidor, solo ve el resultado HTML y no tiene conocimiento del código Ruby que lo generó. Entonces, cuando usamos la extensión .html.erb, estamos indicando que el archivo contiene HTML con incrustaciones de código Ruby. Este tipo de archivo permite la ejecución de código Ruby entre las etiquetas <% %> y <%= %>. Podemos utilizar variables, bucles y otras construcciones de Ruby para generar contenido dinámico.

<br>
Recordemos que el diseño principal (o layout) de nuestra aplicación se encuentra en application.html.erb, que se utiliza para envolver todas las vistas. Esto se utiliza como un marco general para todas las páginas de la aplicación, y las vistas específicas, como new.html.erb, se insertan en el área designada (<%= yield %>) del archico application.html.erb, lo que permite mantener la consistencia en la apariencia y la estructura de nuestro sitio. Por tal motivo, fueron omitidos para simplificar el DOM y para centrarnos en las validaciones de lado del cliente en la vista new.html.erb.

Para ello, agregamos las siguiente lineas de codigo en la parte final de nuestro archivo new.html.erb para evitar que el usuario agregue peliculas con los titulos en blanco. Estas validación que se estan agregando con el script JavaScript son del lado del cliente, en cambio las validaciones que se hicieron en el modelo en Rails en el archivo movie.rb generalmente se aplican en el lado del servidor.

Por lo cual, utilizamos un script JavaScript y una hoja de estilo CSS para realizar validaciones del lado del cliente y resaltar los campos con errores.

```

<script>
  document.querySelector('.form').addEventListener('submit', function (event) {
    document.getElementById('movie_title').classList.remove('validation-error');
    var title = document.querySelector('#movie_title').value;
    if (title.trim() === '') {
      alert('El título no puede estar vacío');
      document.getElementById('movie_title').classList.add('validation-error');
      event.preventDefault();
      return;
    }
    });
</script>

<style>
  .validation-error {
    border: 1px solid red;
  }
</style>

```

- document.querySelector('.form'): Esto selecciona el primer elemento en el documento que tiene la clase 'form'. En el contexto de formularios HTML, esto suele ser el formulario al que se refiere la página.

- addEventListener('submit', function (event) {: Agrega un "escuchador de eventos" al formulario seleccionado. Este escuchador está configurado para activarse cuando el formulario se envía (submit). La función anonima que se pasa como segundo argumento se ejecutará cuando se produzca el evento de envío.

- document.getElementById('movie_title') busca y devuelve el elemento del DOM con el identificador movie_title, es decir devolverá el objeto que representa ese campo de entrada. Con lo cual se podria luego acceder a las propiedades y métodos de este objeto.
  
- .classList.remove('validation-error') quita la clase 'validation-error' de su lista de clases. Esto se hace para eliminar cualquier estilo de validación previo, es decir, elimina la clase 'validation-error' del elemento con ID 'movie_title'

- var title = document.querySelector('#movie_title').value;: Esto selecciona el elemento con el ID 'movie_title' y obtiene el valor de su propiedad value, que es el texto que el usuario ha ingresado en el campo de entrada y lo almacena en la variable title.
  
- if (title.trim() === '') {: Aquí se verifica si el título está vacío después de eliminar cualquier espacio en blanco al principio y al final del texto con el metodo trim().

- alert('El título no puede estar vacío');: Si el título está vacío, se muestra una alerta al usuario indicándole que el título no puede estar vacío.

- document.getElementById('movie_title').classList.add('validation-error');: Se agrega la clase 'validation-error' al elemento con el ID 'movie_title', lo que podría cambiar su apariencia para indicar un error.

- event.preventDefault();: Evita el comportamiento predeterminado del formulario, que es enviar los datos al servidor. Esto detiene la acción de envío del formulario.

- return;: Sale de la función si el título está vacío.

- <style> validation-error { border: 1px solid red; } </style> : Estas líneas de CSS definen un estilo para la clase 'validation-error'. En este caso, están aplicando un borde de 1 píxel de ancho y de color rojo al elemento con esta clase. Esto es consistente con la interacción en JavaScript, donde se agrega o elimina la clase 'validation-error' según si el título está vacío o no.


En resumen, dentro del script de Javascript estamos agregando un event listener al formulario con la clase 'form' que escucha el evento 'submit'.Cuando se envía el formulario, se remueve cualquier estilo de validación anterior al eliminar la clase 'validation-error' del campo de entrada con el ID 'movie_title'.Luego, se obtiene el valor del campo de título y se verifica si está vacío después de quitar espacios en blanco. Si el campo está vacío, se muestra una alerta, se resalta el campo con la clase 'validation-error', se previene el envío del formulario y se sale de la función. Ademas, el bloque de estilo CSS define la apariencia de los campos de entrada con la clase 'validation-error'. En este caso, agrega un borde rojo alrededor del campo.


![Captura de pantalla de 2023-12-21 00-27-43](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/3701d87e-292d-42d7-9fe2-13ccd729aad7)

![Captura de pantalla de 2023-12-21 00-27-52](https://github.com/miguelvega/PracticaCalificada4/assets/124398378/ed975132-8113-4770-8665-59e6d84c1fe1)


```
html
└── head
    ├── title (Rotten Potatoes!)
    ├── link (stylesheet: bootstrap.min.css)
    ├── link (stylesheet: application.self.css)
    ├── script (jquery)
    ├── script (jquery_ujs)
    └── script (application.self.js)
└── body
    ├── nav (navbar)
    │   └── h1 (title: Rotten Potatoes!)
    ├── div (container)
    │   └── main (main)
    │       └── h2 (Create New Movie)
    │       └── form (form, action="/movies")
    │           ├── input (utf8)
    │           ├── input (authenticity_token)
    │           ├── label (for="movie_title", Title)
    │           ├── input (text, name="movie[title]", id="movie_title")
    │           ├── label (for="movie_rating", Rating)
    │           ├── select (name="movie[rating]", id="movie_rating")
    │               └── option (value="G", G)
    │               └── option (value="PG", PG)
    │               └── option (value="PG-13", PG-13)
    │               └── option (value="R", R)
    │           ├── label (for="movie_release_date", Released On)
    │           ├── select (id="movie_release_date_1i", name="movie[release_date(1i)]")
    │               └── option (value="2018", 2018)
    │               └── option (value="2019", 2019)
    │               └── ... (opciones para otros años)
    │           ├── select (id="movie_release_date_2i", name="movie[release_date(2i)]")
    │               └── option (value="1", January)
    │               └── option (value="2", February)
    │               └── ... (opciones para otros meses)
    │           ├── select (id="movie_release_date_3i", name="movie[release_date(3i)]")
    │               └── option (value="1", 1)
    │               └── option (value="2", 2)
    │               └── ... (opciones para otros días)
    │           ├── br
    │           ├── input (submit, name="commit", value="Save Changes")
    │           └── a (href="/movies", class="btn btn-secondary")
    │       └── script
    │       └── style (validation-error)
    └── script (validación del formulario)


```

### 3. En el código utilizado en la sección de eventos y funciones callback, supongamos que no puedes modificar el código del servidor para añadir la clase CSS adult a las filas de la tabla movies. ¿Cómo identificaría las filas que están ocultas utilizando sólo código JavaScript del lado cliente?

Recordemos que hasta el momento en la vista index.hrml.erb:
- Utiliza un formulario tradicional (form_tag) para la actualización.
- Se basa en el envío de un formulario para actualizar la página según las selecciones del usuario.
- Utiliza campos ocultos (hidden_field_tag) para almacenar valores como dirección y tipo de clasificación.
- Estos campos son parte del formulario y se envían con el formulario cuando se actualiza la página.


En esta pregunta, vamos a proporcionar un tratamiendo de la informacion del lado del cliente mediante codigo de Javascript para actualizar la URL basándose en los checkboxes seleccionados, detectar cambios en los checkboxes y ejecutar funciones para actualizar dinamicamente de la URL sin recargar la página y mostrar información en la consola de las peliculas que estan ocultas debido a los checkboxes marcados, en otras palabras, mostraremos las peliculas correspondiente a los checkboxes desmarcados. 

Cambiamos la parte del codigo de la vista index.html.erb 
```
<%= form_tag movies_path, method: :get, id: 'ratings_form' do %>
  <% @all_ratings.each do |rating| %>
    <div class="form-check form-check-inline">
      <%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
      <%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>
    </div>
  <% end %>
  <%= hidden_field_tag "direction", params[:direction] %>
  <%= hidden_field_tag "sort", params[:sort] %>
  <%= submit_tag 'Refresh', id: 'rating_submit', class: 'btn btn-primary' %>  
<% end %>

```
Por el siguiente codigo, ya que no utilizaremos el formulario de envío tradicional (form_tag) para actualizar la página, debido a que la actualización ocurrira dinámicamente a través de JavaScript sin necesidad de recargar la página

```
<div id="ratings_form">
  <% @all_ratings.each do |rating| %>
    <div class="form-check form-check-inline">
      <%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>
      <%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
    </div>
  <% end %>
  
</div>

```
- `<div id="ratings_form">`: Abre un contenedor <div> con el atributo de identificación (id) establecido en "ratings_form". Este contenedor probablemente contendrá un conjunto de checkboxes relacionados con las clasificaciones de las películas.

- `<% @all_ratings.each do |rating| %>`: Inicia un bucle Ruby que itera sobre cada elemento en la colección @all_ratings. Esta colección probablemente contiene las clasificaciones disponibles para las películas.

- `<div class="form-check form-check-inline">`: Abre un nuevo contenedor <div> con clases de Bootstrap (form-check y form-check-inline). Esto se usa comúnmente para estilizar checkboxes y radio buttons en formularios.

- `<%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>`: Genera un checkbox. Desglosemos los parámetros:
    - "ratings[#{rating}]": Nombre del checkbox, probablemente para asociarlo a una clasificación específica.
    - "1": Valor predeterminado del checkbox cuando está marcado.
    - @ratings_to_show.include?(rating): Verifica si la clasificación actual (rating) debe estar marcada inicialmente según el estado actual del modelo (@ratings_to_show).
    - class: 'form-check-input': Clase de Bootstrap para estilizar el checkbox.

- `<%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>`: Genera una etiqueta asociada al checkbox para describir la clasificación. Desglosemos los parámetros:
    - "ratings[#{rating}]": Asocia la etiqueta al checkbox con el mismo nombre.
    - rating: Texto de la etiqueta, que probablemente sea la clasificación.
    - class: 'form-check-label': Clase de Bootstrap para estilizar la etiqueta.

- `<% end %>`: Cierra el bucle Ruby.

- `</div>`: Cierra el contenedor <div> del paso 3.

- `</div>`: Cierra el contenedor principal <div> con identificación "ratings_form".

En resumen, este código genera un conjunto de checkboxes en una vista de Rails para clasificaciones de películas. Utiliza un bucle para crear checkboxes y etiquetas asociadas a partir de un conjunto predefinido de clasificaciones (@all_ratings) que es un metodo de clase del modelo movie. La marca de cada checkbox depende de si la clasificación correspondiente está presente en @ratings_to_show, una variable proporcionada por el controlador. Este código permite al usuario filtrar películas por clasificación mediante checkboxes en la interfaz

Ademas, agregamos la siguiente condicional en la accion index, ya que estamos tratando de manejar diferentes formatos de entrada y asegurarse de que @ratings_to_show esté en el formato correcto que se espera más adelante en la acción index. 

```ruby

if @ratings_to_show.is_a?(String)
      @ratings_to_show = @ratings_to_show.split(',')
end

```
Pues, la manipulación de @ratings_to_show como Hash o String depende de cómo se almacenan y pasan los datos desde y hacia la vista.


Luego, modificamos el metodo de clase `with_ratings` de modelo movie dado en el archivo movie.rb, recuerda que tiene como propósito filtrar las películas según las clasificaciones proporcionadas.

```ruby
def self.with_ratings(ratings)
    if ratings.present?
      where('UPPER(rating) IN (?)', ratings.map { |rating| rating.to_s.upcase })
    else 
      all
    end
  end
```

- if ratings.present?: Verifica si la variable ratings no está vacía o nil. present? devuelve true si el objeto no está vacío.

- where('UPPER(rating) IN (?)', ratings.map { |rating| rating.to_s.upcase }):
    - ratings.map { |rating| rating.to_s.upcase }: Convierte cada clasificación en mayúsculas y crea un nuevo array con las clasificaciones modificadas.
    - where('UPPER(rating) IN (?)', ...): Utiliza una cláusula SQL WHERE para filtrar las películas cuya clasificación (en mayúsculas) esté incluida en el array resultante. Esto se traduce a una consulta SQL como "SELECT * FROM movies WHERE UPPER(rating) IN ('G', 'PG', 'PG-13')".

- else all: Si no se proporcionan clasificaciones, devuelve todas las películas. Esto significa que si ratings está vacío, la función devuelve todas las películas sin ningún filtro.

En resumen, la función with_ratings permite filtrar las películas según las clasificaciones proporcionadas. Este tipo de método es útil en situaciones en las que deseas recuperar un subconjunto específico de registros de la base de datos basándote en ciertos criterios, en este caso, las clasificaciones de las películas.


```javascript

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const checkboxes = document.querySelectorAll('#ratings_form input[type="checkbox"]');
    const movies = <%= raw @movies.to_json %>; // Convierte las películas a un array de JavaScript

    function updateURL() {
      const ratings = Array.from(checkboxes)
        .filter(cb => cb.checked)
        .map(cb => cb.name.split("[")[1].split("]")[0]);

      const url = new URL(window.location.href);
      url.searchParams.set("ratings", ratings.join(","));

      window.location.href = url.toString();
    }

    function logUncheckedMovies() {
      const uncheckedMovies = Array.from(checkboxes)
        .filter(cb => !cb.checked)
        .map(cb => cb.name.split("[")[1].split("]")[0]);

      console.log('Películas con rating desmarcado:', uncheckedMovies);

      // Mostrar en consola los nombres de todas las películas correspondientes a los checkboxes desmarcados
      uncheckedMovies.forEach(rating => {
        const moviesWithRating = movies.filter(movie => movie.rating === rating);
        const movieNames = moviesWithRating.map(movie => movie.title);
        console.log(`Películas con rating ${rating}:`, movieNames);
      });
    }

    checkboxes.forEach(function (checkbox) {
      checkbox.addEventListener('change', function () {
        if (Array.from(checkboxes).every(cb => !cb.checked)) {
          // Si todos los checkboxes están desmarcados, marcar todos
          checkboxes.forEach(cb => cb.checked = true);
        }

        updateURL();
        logUncheckedMovies();
      });
    });
  });
</script>

```


### 4. Siguiendo la estrategia del ejemplo de jQuery de la misma sección anterior de eventos y funciones callback, utiliza JavaScript para implementar un conjunto de casillas de verificación (checkboxes) para la página que muestra la lista de películas, una por cada calificación (G, PG, etcétera), que permitan que las películas correspondientes permanezcan en la lista cuando están marcadas. Cuando se carga la página por primera vez, deben estar marcadas todas; desmarcar alguna de ellas debe esconder las películas con la clasificación a la que haga referencia la casilla desactivada.

### 5. Escribe el código AJAX necesario para crear menús en cascada basados en una asociación has_many. Esto es, dados los modelos de Rails A y B, donde A has_many (tiene muchos) B, el primer menú de la pareja tiene que listar las opciones de A, y cuando se selecciona una, devolver las opciones de B correspondientes y rellenar el menú B.

### 6. Extienda la funcionalidad del ejemplo dado en la actividad de AJAX: JavaScript asíncrono y XML de forma que, si el usuario expande u oculta repetidamente la misma fila de la tabla de películas, sólo se haga una única petición al servidor para la película en cuestión la primera vez. En otras palabras, implementa una memoria caché con JavaScript en el lado cliente para la información de la película devuelta en cada llamada AJAX.
