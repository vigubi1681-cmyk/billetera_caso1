# Caso 1: Billetera Digital (Servlet + JSP)

Aplicación web en Java puro que simula una billetera digital.
Datos en memoria (HttpSession), vista con JSP + JSTL + Bootstrap, mensajes con SweetAlert2.

## Versiones utilizadas
- JDK: 21.0.13 
- Apache Tomcat: 10.1.0
- Maven Wrapper: incluido (`mvnw`) 3.9.16
- Bootstrap 5.3.8 y SweetAlert2 11 (por CDN)

## Ejecución
1. Compilar: `.\mvnw.cmd clean package`
2. Se genera `target/caso1.war`
3. Copiar el .war en la carpeta `webapps` de Tomcat 10.1+ e iniciarlo
4. Abrir http://localhost:8080/caso1/

## Funcionalidad
- Saldo inicial: S/ 250.00 e historial vacío.
- Recarga: suma un monto positivo al saldo.
- Gasto: descuenta un monto positivo menor o igual al saldo disponible.
- Montos vacíos, no numéricos, cero o negativos se rechazan con un mensaje.
- El historial muestra primero el movimiento más reciente.
