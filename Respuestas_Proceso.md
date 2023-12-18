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

Los ejercicios a partir de aquí se recomiendan hacerlos en orden.
## Pregunta: (Para responder esta pregunta utiliza el repositorio y las actividades que has desarrollado de Introducción a Rails). Modifique la lista de películas de la siguiente manera. Cada modificación va a necesitar que realice un cambio en una capa de abstracción diferente

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

###  ¿Qué sucede en JavaScript con el DIP en este ejemplo? 

Sabemos que en JavaScript utiliza prototipos que permiten a los objetos heredar propiedades y métodos de otros objetos a través de su cadena de prototipos. Donde cada objeto tiene una propiedad privada que mantiene un enlace a otro objeto llamado su prototipo. Ese objeto prototipo tiene su propio prototipo, y así sucesivamente hasta que se alcanza un objeto cuyo prototipo es null. Ahora bien en este ejemplo al tener esta particularidad se tendria que pasar la dependecias mediante metodos mantiendo un enlace al realizar la prueba durante un día laboral.

## Pregunta: (para responder esta pregunta utiliza el repositorio y las actividades que has realizado de Rails avanzado, en particular asociaciones) - 2 puntos

1. Extienda el código del controlador del código siguiente dado con los métodos edit y update para las críticas. Usa un filtro de controlador para asegurarte de que un usuario sólo puede editar o actualizar sus propias críticas. Revisa el código dado en la evaluación y actualiza tus repositorios de actividades (no se admite nada nuevo aquí). Debes mostrar los resultados. 

    
