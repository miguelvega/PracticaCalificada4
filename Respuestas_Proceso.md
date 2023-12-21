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


### 3. En el código utilizado en la sección de eventos y funciones callback, supongamos que no puedes modificar el código del servidor para añadir la clase CSS adult a las filas de la tabla movies. ¿Cómo identificaría las filas que están ocultas utilizando sólo código JavaScript del lado cliente?

### 4. Siguiendo la estrategia del ejemplo de jQuery de la misma sección anterior de eventos y funciones callback, utiliza JavaScript para implementar un conjunto de casillas de verificación (checkboxes) para la página que muestra la lista de películas, una por cada calificación (G, PG, etcétera), que permitan que las películas correspondientes permanezcan en la lista cuando están marcadas. Cuando se carga la página por primera vez, deben estar marcadas todas; desmarcar alguna de ellas debe esconder las películas con la clasificación a la que haga referencia la casilla desactivada.

### 5. Escribe el código AJAX necesario para crear menús en cascada basados en una asociación has_many. Esto es, dados los modelos de Rails A y B, donde A has_many (tiene muchos) B, el primer menú de la pareja tiene que listar las opciones de A, y cuando se selecciona una, devolver las opciones de B correspondientes y rellenar el menú B.

### 6. Extienda la funcionalidad del ejemplo dado en la actividad de AJAX: JavaScript asíncrono y XML de forma que, si el usuario expande u oculta repetidamente la misma fila de la tabla de películas, sólo se haga una única petición al servidor para la película en cuestión la primera vez. En otras palabras, implementa una memoria caché con JavaScript en el lado cliente para la información de la película devuelta en cada llamada AJAX.
