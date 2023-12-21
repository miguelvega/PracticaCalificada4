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

