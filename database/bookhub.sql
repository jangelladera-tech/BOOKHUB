-- ==========================================================
-- SISTEMA DE GESTIÓN BIBLIOTECARIA: BOOKHUB
-- Base de datos relacional para MySQL 8.0+ / 5.7+
-- ==========================================================

DROP DATABASE IF EXISTS bookhub;
CREATE DATABASE bookhub CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bookhub;

-- 1. TABLA: ROLES
CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- 2. TABLA: USUARIOS
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    id_rol INT NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO', 'SUSPENDIDO') DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. TABLA: CATEGORÍAS
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(50) DEFAULT 'bi-bookmark-check'
) ENGINE=InnoDB;

-- 4. TABLA: AUTORES
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    nacionalidad VARCHAR(100),
    biografia TEXT,
    foto_url VARCHAR(255)
) ENGINE=InnoDB;

-- 5. TABLA: LIBROS
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    id_autor INT NOT NULL,
    id_categoria INT NOT NULL,
    editorial VARCHAR(100),
    anio_publicacion INT,
    paginas INT,
    ejemplares_totales INT NOT NULL DEFAULT 1,
    ejemplares_disponibles INT NOT NULL DEFAULT 1,
    portada_url VARCHAR(255),
    descripcion TEXT,
    calificacion DECIMAL(3,2) DEFAULT 5.00,
    destacado BOOLEAN DEFAULT FALSE,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_libro_autor FOREIGN KEY (id_autor) REFERENCES autores(id_autor) ON UPDATE CASCADE,
    CONSTRAINT fk_libro_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON UPDATE CASCADE,
    INDEX idx_libro_titulo (titulo),
    INDEX idx_libro_categoria (id_categoria),
    INDEX idx_libro_autor (id_autor)
) ENGINE=InnoDB;

-- 6. TABLA: PRÉSTAMOS
CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real DATE NULL,
    estado ENUM('ACTIVO', 'DEVUELTO', 'VENCIDO') DEFAULT 'ACTIVO',
    observaciones TEXT,
    CONSTRAINT fk_prestamo_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_prestamo_libro FOREIGN KEY (id_libro) REFERENCES libros(id_libro) ON DELETE RESTRICT,
    INDEX idx_prestamo_usuario (id_usuario),
    INDEX idx_prestamo_libro (id_libro),
    INDEX idx_prestamo_estado (estado)
) ENGINE=InnoDB;

-- 7. TABLA: DEVOLUCIONES
CREATE TABLE devoluciones (
    id_devolucion INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL UNIQUE,
    fecha_devolucion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_libro ENUM('BUENO', 'REGULAR', 'DANADO') DEFAULT 'BUENO',
    multa DECIMAL(8,2) DEFAULT 0.00,
    observaciones TEXT,
    CONSTRAINT fk_devolucion_prestamo FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. TABLA: RESERVAS
CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento DATE NOT NULL,
    estado ENUM('PENDIENTE', 'COMPLETADA', 'CANCELADA', 'EXPIRADA') DEFAULT 'PENDIENTE',
    CONSTRAINT fk_reserva_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_reserva_libro FOREIGN KEY (id_libro) REFERENCES libros(id_libro) ON DELETE CASCADE,
    INDEX idx_reserva_usuario (id_usuario),
    INDEX idx_reserva_libro (id_libro),
    INDEX idx_reserva_estado (estado)
) ENGINE=InnoDB;

-- ==========================================================
-- DATOS DE PRUEBA / SEMILLA
-- ==========================================================

-- Roles
INSERT INTO roles (id_rol, nombre, descripcion) VALUES
(1, 'ADMINISTRADOR', 'Acceso total a la administración de usuarios, catálogo, préstamos y métricas'),
(2, 'USUARIO', 'Estudiante o docente con privilegios para consultar, solicitar préstamos y reservar');

-- Contraseñas en SHA-256:
-- 'admin123' -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa82280f1a8230e88
-- 'usuario123' -> 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
INSERT INTO usuarios (id_usuario, nombre, apellido, email, password, telefono, id_rol, estado) VALUES
(1, 'Administrador', 'Sistema', 'admin@bookhub.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa82280f1a8230e88', '+51 987654321', 1, 'ACTIVO'),
(2, 'Juan', 'Pérez', 'juan.perez@universidad.edu', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '+51 912345678', 2, 'ACTIVO'),
(3, 'María', 'López', 'maria.lopez@universidad.edu', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '+51 955443322', 2, 'ACTIVO');

-- Categorías
INSERT INTO categorias (id_categoria, nombre, descripcion, icono) VALUES
(1, 'Ingeniería y Tecnología', 'Ciencias de la computación, robótica, telecomunicaciones y sistemas', 'bi-cpu'),
(2, 'Literatura y Ficción', 'Grandes obras clásicas, novelas universales y narrativa contemporánea', 'bi-book-half'),
(3, 'Ciencias Básicas', 'Matemáticas, física, química y biología para formación universitaria', 'bi-calculator'),
(4, 'Ciencias Sociales', 'Sociología, economía, derecho, educación y ciencia política', 'bi-people'),
(5, 'Filosofía e Historia', 'Corrientes filosóficas, historia universal y pensamiento crítico', 'bi-hourglass-split');

-- Autores
INSERT INTO autores (id_autor, nombre, nacionalidad, biografia, foto_url) VALUES
(1, 'Gabriel García Márquez', 'Colombiano', 'Premio Nobel de Literatura 1982, figura emblemática del realismo mágico hispanoamericano.', 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&q=80&w=300'),
(2, 'Frank Herbert', 'Estadounidense', 'Reconocido novelista de ciencia ficción, autor de la trascendental saga Dune.', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=300'),
(3, 'Yuval Noah Harari', 'Israelí', 'Historiador, filósofo y escritor, profesor de la Universidad Hebrea de Jerusalén.', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=300'),
(4, 'Jane Austen', 'Británica', 'Destacada novelista del siglo XIX cuyas obras exploran con ingenio la moral y la sociedad de su época.', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=300'),
(5, 'Robert C. Martin', 'Estadounidense', 'Ingeniero de software apodado Uncle Bob, coautor del Manifiesto Ágil y Clean Code.', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=300');

-- Libros
INSERT INTO libros (id_libro, titulo, isbn, id_autor, id_categoria, editorial, anio_publicacion, paginas, ejemplares_totales, ejemplares_disponibles, portada_url, descripcion, calificacion, destacado) VALUES
(1, 'Cien Años de Soledad', '978-0307474728', 1, 2, 'Sudamericana', 1967, 471, 5, 4, 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=600', 'La épica historia de la familia Buendía en el pueblo mítico de Macondo. Obra fundamental de la literatura en español.', 4.90, TRUE),
(2, 'Clean Code: A Handbook of Agile Software Craftsmanship', '978-0132350884', 5, 1, 'Prentice Hall', 2008, 464, 4, 3, 'https://images.unsplash.com/photo-1532012164546-f432f2e3777f?auto=format&fit=crop&q=80&w=600', 'Principios, patrones y mejores prácticas para escribir software legible, mantenible y de calidad profesional.', 4.85, TRUE),
(3, 'Dune', '978-0441172719', 2, 2, 'Chilton Books', 1965, 688, 3, 2, 'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=600', 'La odisea de Paul Atreides en el desértico planeta Arrakis, eje del poder político y la especia melange.', 4.80, TRUE),
(4, 'Sapiens: De animales a dioses', '978-0062316097', 3, 5, 'Debate', 2014, 496, 6, 5, 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=600', 'Un recorrido por la historia de la humanidad desde los primeros cazadores hasta las revoluciones científicas.', 4.75, TRUE),
(5, 'Orgullo y Prejuicio', '978-0141439518', 4, 2, 'T. Egerton', 1813, 432, 4, 4, 'https://images.unsplash.com/photo-1476275466078-4007374efbbe?auto=format&fit=crop&q=80&w=600', 'La relación entre la audaz Elizabeth Bennet y el aristocrático señor Darcy en la Inglaterra rural.', 4.80, FALSE),
(6, 'The Clean Coder: A Code of Conduct for Professional Programmers', '978-0137081073', 5, 1, 'Prentice Hall', 2011, 256, 3, 3, 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&q=80&w=600', 'Guía fundamental sobre la ética, la responsabilidad y la actitud del programador profesional.', 4.70, FALSE);

-- Préstamos de prueba
INSERT INTO prestamos (id_prestamo, id_usuario, id_libro, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real, estado, observaciones) VALUES
(1, 2, 1, '2026-09-01', '2026-09-15', '2026-09-14', 'DEVUELTO', 'Devuelto en excelentes condiciones'),
(2, 2, 2, '2026-09-18', '2026-10-02', NULL, 'ACTIVO', 'Préstamo vigente para proyecto de ingeniería'),
(3, 3, 3, '2026-09-20', '2026-10-04', NULL, 'ACTIVO', 'Préstamo para curso de narrativa contemporánea');

-- Devoluciones de prueba
INSERT INTO devoluciones (id_devolucion, id_prestamo, fecha_devolucion, estado_libro, multa, observaciones) VALUES
(1, 1, '2026-09-14 16:30:00', 'BUENO', 0.00, 'Sin daños observados');

-- Reservas de prueba
INSERT INTO reservas (id_reserva, id_usuario, id_libro, fecha_reserva, fecha_vencimiento, estado) VALUES
(1, 3, 1, CURRENT_TIMESTAMP, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), 'PENDIENTE'),
(2, 2, 4, CURRENT_TIMESTAMP, DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY), 'PENDIENTE');
