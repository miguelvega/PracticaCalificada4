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


###  ¿Qué sucede en JavaScript con el DIP en este ejemplo? 

Sabemos que en JavaScript utiliza prototipos que permiten a los objetos heredar propiedades y métodos de otros objetos a través de su cadena de prototipos. Donde cada objeto tiene una propiedad privada que mantiene un enlace a otro objeto llamado su prototipo. Ese objeto prototipo tiene su propio prototipo, y así sucesivamente hasta que se alcanza un objeto cuyo prototipo es null. Ahora bien en este ejemplo al tener esta particularidad se tendria que pasar la dependecias mediante metodos mantiendo un enlace al realizar la prueba durante un día laboral.

## Pregunta: (para responder esta pregunta utiliza el repositorio y las actividades que has realizado de Rails avanzado, en particular asociaciones) - 2 puntos

1. Extienda el código del controlador del código siguiente dado con los métodos edit y update para las críticas. Usa un filtro de controlador para asegurarte de que un usuario sólo puede editar o actualizar sus propias críticas. Revisa el código dado en la evaluación y actualiza tus repositorios de actividades (no se admite nada nuevo aquí). Debes mostrar los resultados. 

    
