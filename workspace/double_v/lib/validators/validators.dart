// This file contain custom validators for the application
import 'package:string_validator/string_validator.dart';

// Validate name and last name fields
// Check they are not empty
// Check for only values 'azAz'
String nameValidator(String string) {
  if (string == '') return 'Campo obligatorio';
  if (isAlpha(string)) return null;
  return 'No se aceptan numeros o caracteres especiales';
}

// Validate address
// Check if it's empty
String addressValidator(String string) {
  if (string == '') return 'Campo obligatorio';
  return null;
}

// Email validator
// Check if the email signed is a correct Email
String emailValidator(String email) {
  if (isEmail(email))
    return null;
  else
    return 'Ingrese un email valido';
}
