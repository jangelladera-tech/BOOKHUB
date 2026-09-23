# 📚 BOOKHUB - Sistema de Gestión de Biblioteca Universitaria y Digital

**BOOKHUB** es una plataforma web integral para la gestión bibliotecaria universitaria y digital desarrollada con arquitectura **MVC**, **Java (JSP, Servlets, JavaBeans, DAO)**, **MySQL**, **Apache Tomcat**, **Bootstrap 5** y **Maven**.

El sistema permite a la comunidad académica consultar libros, reservar ejemplares en tiempo real, gestionar préstamos y devoluciones, y ofrece a los administradores un panel de control con métricas e inventario completo.

---

## 📋 1. Requisitos del Sistema

Para compilar y ejecutar BOOKHUB necesitas:
- **Java Development Kit (JDK)**: Versión 8 o superior (Java 8, 11, 17 o 21).
- **Apache Maven**: Versión 3.6 o superior.
- **MySQL Server**: Versión 5.7 o superior (o MySQL 8.0+, MariaDB 10.4+ / XAMPP).
- **Apache Tomcat**: Versión 8.5 o 9.0 (o ejecutar directamente mediante el plugin Maven integrado `tomcat7:run`).
- **Navegador web moderno**: Chrome, Edge, Firefox, Safari o similar.

---

## 🗄️ 2. Cómo Crear la Base de Datos

Abre tu gestor de base de datos preferido (MySQL Workbench, phpMyAdmin, DBeaver o la consola de MySQL) y ejecuta:

```sql
CREATE DATABASE IF NOT EXISTS bookhub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## 📜 3. Cómo Ejecutar `database/bookhub.sql`

El script se encuentra en la carpeta `database/bookhub.sql`. Puedes importarlo de cualquiera de las siguientes formas:

### Opción A: Desde la Consola de MySQL / Terminal
```bash
mysql -u root -p bookhub < database/bookhub.sql
```

### Opción B: Desde MySQL Workbench o phpMyAdmin
1. Abre MySQL Workbench o phpMyAdmin.
2. Selecciona la opción **Importar** o abre el archivo [`database/bookhub.sql`](file:///C:/Users/CARITO/Desktop/Nueva%20carpeta/database/bookhub.sql).
3. Ejecuta todo el script.

El script creará automáticamente las 8 tablas relacionales (`roles`, `usuarios`, `categorias`, `autores`, `libros`, `prestamos`, `devoluciones`, `reservas`) y poblará la base de datos con autores, categorías, libros con portadas y usuarios de prueba.

---

## ⚙️ 4. Cómo Configurar la Conexión a MySQL

Edita el archivo de configuración localizado en:
[`src/main/resources/db.properties`](file:///C:/Users/CARITO/Desktop/Nueva%20carpeta/src/main/resources/db.properties)

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8
db.user=root
db.password=tu_contraseña_aqui
```

> **Nota:** Si tu usuario `root` de MySQL no tiene contraseña (caso común en XAMPP o Laragon), deja `db.password=` en blanco.

---

## 🚀 5. Cómo Configurar Apache Tomcat

### Forma 1: Plugin Maven Integrado (Recomendada - Sin instalación manual)
El proyecto ya cuenta con el plugin de Tomcat configurado en el [`pom.xml`](file:///C:/Users/CARITO/Desktop/Nueva%20carpeta/pom.xml). Simplemente ejecuta:

```bash
mvn tomcat7:run
```
El servidor se iniciará automáticamente en el puerto `8080` bajo la ruta `/bookhub`.

### Forma 2: En Tomcat 9 o Tomcat 8.5 Externo
1. Compila el paquete WAR del proyecto:
   ```bash
   mvn clean package
   ```
2. Esto generará el archivo `target/bookhub.war`.
3. Copia `bookhub.war` a la carpeta `webapps/` de tu instalación de Apache Tomcat.
4. Inicia Tomcat ejecutando `bin/startup.bat` (Windows) o `bin/startup.sh` (Linux/Mac).
5. Accede a `http://localhost:8080/bookhub`.

---

## 💻 6. Cómo Ejecutar el Proyecto

1. Asegúrate de que el servicio de MySQL esté iniciado.
2. Abre una terminal en la carpeta raíz del proyecto `BOOKHUB`.
3. Ejecuta el comando:
   ```bash
   mvn tomcat7:run
   ```
4. Abre tu navegador e ingresa a:
   [**http://localhost:8080/bookhub**](http://localhost:8080/bookhub)

---

## 👥 7. Usuarios de Prueba Preconfigurados

Todas las contraseñas están almacenadas de forma segura con hash **SHA-256**:

| Rol | Correo Electrónico | Contraseña Plana | Acceso / Privilegios |
| :--- | :--- | :--- | :--- |
| **Administrador** | `admin@bookhub.com` | `admin123` | Dashboard administrativo, gestión de libros, préstamos, devoluciones, reservas y usuarios |
| **Lector (Usuario)** | `juan.perez@universidad.edu` | `usuario123` | Panel de lector, consulta de catálogo, reservas de libros y seguimiento de préstamos |
| **Lector (Usuario)** | `maria.lopez@universidad.edu` | `usuario123` | Panel de lector y reservas |

---

## 🏛️ 8. Estructura Completa del Proyecto

```text
BOOKHUB/
├── pom.xml                                  # Configuración de dependencias Maven y Tomcat
├── README.md                                # Guía de instalación y arquitectura
├── .gitignore                               # Exclusiones de Git
├── database/
│   └── bookhub.sql                          # Esquema de tablas relacionales y datos semilla
└── src/
    └── main/
        ├── resources/
        │   └── db.properties                # Credenciales y conexión JDBC MySQL
        ├── java/
        │   └── com/bookhub/
        │       ├── beans/                   # JavaBeans (Entidades del Modelo)
        │       │   ├── Rol.java
        │       │   ├── Usuario.java
        │       │   ├── Categoria.java
        │       │   ├── Autor.java
        │       │   ├── Libro.java
        │       │   ├── Prestamo.java
        │       │   ├── Devolucion.java
        │       │   ├── Reserva.java
        │       │   └── Estadisticas.java
        │       ├── dao/                     # Capa de Acceso a Datos (JDBC & PreparedStatements)
        │       │   ├── UsuarioDAO.java
        │       │   ├── CategoriaDAO.java
        │       │   ├── AutorDAO.java
        │       │   ├── LibroDAO.java
        │       │   ├── PrestamoDAO.java
        │       │   ├── DevolucionDAO.java
        │       │   └── ReservaDAO.java
        │       ├── servlet/                 # Controladores MVC (Rutas y Peticiones HTTP)
        │       │   ├── HomeServlet.java            # /index, /
        │       │   ├── CatalogoServlet.java        # /catalogo
        │       │   ├── LibroDetalleServlet.java    # /libro
        │       │   ├── LoginServlet.java           # /login
        │       │   ├── RegistroServlet.java        # /registro
        │       │   ├── LogoutServlet.java          # /logout
        │       │   ├── UsuarioDashboardServlet.java# /usuario/*
        │       │   ├── ReservaServlet.java         # /usuario/reservar
        │       │   ├── AdminDashboardServlet.java  # /admin/dashboard
        │       │   ├── AdminLibrosServlet.java     # /admin/libros
        │       │   ├── AdminUsuariosServlet.java   # /admin/usuarios
        │       │   ├── AdminAutoresServlet.java    # /admin/autores
        │       │   ├── AdminCategoriasServlet.java # /admin/categorias
        │       │   ├── AdminPrestamosServlet.java  # /admin/prestamos
        │       │   └── AdminReservasServlet.java   # /admin/reservas
        │       ├── filter/                  # Filtros de Seguridad y Codificación
        │       │   ├── EncodingFilter.java         # Codificación UTF-8
        │       │   └── AuthFilter.java             # Protección /usuario/* y /admin/*
        │       └── util/                    # Utilidades Generales
        │           ├── DatabaseUtil.java           # Manejador centralizado de conexiones
        │           └── PasswordUtil.java           # Hashing SHA-256 para contraseñas
        └── webapp/                          # Capa de Vistas y Recursos Web
            ├── assets/
            │   ├── css/styles.css           # Estilos personalizados y tema Bootstrap 5
            │   └── js/main.js               # Interactividad y rellenado de modales
            ├── WEB-INF/
            │   ├── web.xml                  # Descriptor de despliegue
            │   └── views/
            │       ├── components/
            │       │   ├── navbar.jsp       # Barra de navegación adaptable a roles
            │       │   └── footer.jsp       # Pie de página institucional
            │       ├── catalogo.jsp         # Catálogo interactivo con filtros
            │       ├── detalle-libro.jsp    # Ficha técnica y acción de reserva
            │       ├── login.jsp            # Inicio de sesión
            │       ├── registro.jsp         # Registro de nuevos lectores
            │       ├── usuario/             # Vistas de socio / lector
            │       │   ├── dashboard.jsp
            │       │   ├── prestamos.jsp
            │       │   ├── reservas.jsp
            │       │   └── devoluciones.jsp
            │       └── admin/               # Vistas del panel de administración
            │           ├── dashboard.jsp
            │           ├── libros.jsp
            │           ├── usuarios.jsp
            │           ├── autores.jsp
            │           ├── categorias.jsp
            │           ├── prestamos.jsp
            │           └── reservas.jsp
            └── index.jsp                    # Página de inicio principal
```

---

## 🛡️ Seguridad Implementada

1. **Autenticación y Sesiones**: Manejo mediante `HttpSession`, verificación de credenciales con hash SHA-256.
2. **Autorización basada en Roles**: Mediante `AuthFilter`, las rutas `/admin/*` están estrictamente restringidas al rol `ADMINISTRADOR`. Las rutas `/usuario/*` requieren sesión activa.
3. **PreparedStatements**: Todas las consultas a MySQL utilizan parámetros enlazados para prevenir inyecciones SQL (SQL Injection).
4. **Integridad Transaccional**: Registro de préstamos y devoluciones manejado mediante transacciones (`setAutoCommit(false)`, `commit()`, `rollback()`) para garantizar consistencia entre las tablas `prestamos`, `devoluciones` y el stock de `libros`.
