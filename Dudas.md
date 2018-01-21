# Bases de datos

## La base de datos relacional

* En las relaciones 1-n, ¿cuándo se hace una matriz de relación y cuándo no? ¿Es lo mismo que hablar de relaciones n-1?

* Definiciones de funcionalidad y parcialidad

* Ejemplo de relación 0,1 - 0,1

* Para jerarquías de clasificación (relaciones de herencia): ¿ejemplo de las 3 variantes? ¿Cuándo conviene cada una?

* "Las relaciones de agregación no modifican el modo en que se pasan las relaciones al modelo físico de datos. Dependen exclusivamente de la cardinalidad de las relaciones"

    ¿Qué significa esto? (Diapositiva 40)

* Reglas 6 y 7

* ¿Como se modelan los UNIQUE en el Power Designer?

* Cuando hay relaciones de composición encadenadas (como en el ejercicio sala -> sector -> seccion) y se usan claves de negocio, sala ¿va a tener los identificadores de todas las tablas de la cadena?

## Restricciones

* Interacción entre PKs y Unique Constraints. ¿Se puede repetir un valor de la columna marcada como Unique si la PK no se repite? Si no se puede, ¿cómo hago para que se pueda? (Lo queremos hacer en Tema 2 - Ejercicio 3 - Tabla asignación)