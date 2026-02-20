CREATE TABLE Rol (
    Id_Rol INT AUTO_INCREMENT PRIMARY KEY
COMMENT 'Numero unico que diferencia el tipo de rol',
    Nombre_Rol VARCHAR(50) NOT NULL UNIQUE
COMMENT 'Nombre del Rol'
);
CREATE TABLE Usuario (
    Id_Usuario INT AUTO_INCREMENT PRIMARY KEY 
    COMMENT 'Identificador único del usuario',
    
    Id_Rol INT NOT NULL 
    COMMENT 'Rol asignado al usuario (clave foránea)',
    
    Nombre_Completo VARCHAR(100) NOT NULL 
    COMMENT 'Nombre completo del usuario',
    
    Nombre_Usuario VARCHAR(50) NOT NULL UNIQUE 
    COMMENT 'Nombre de usuario para iniciar sesión',
    
    Correo VARCHAR(120) NOT NULL UNIQUE 
    COMMENT 'Correo electrónico del usuario',
    
    Telefono VARCHAR(20) 
    COMMENT 'Número de teléfono del usuario',
    
    Direccion VARCHAR(150) 
    COMMENT 'Dirección de residencia del usuario',
    
    Estado ENUM('activo','inactivo') NOT NULL DEFAULT 'activo' 
    COMMENT 'Usuarios dispobibles',
    
    Contrasena VARCHAR(255) NOT NULL 
    COMMENT 'Contraseña del usuario (almacenada encriptada)',

    FOREIGN KEY (Id_Rol) REFERENCES Rol(Id_Rol)
        ON DELETE CASCADE ON UPDATE CASCADE
)
COMMENT 'Tabla que almacena los usuarios del sistema y su rol asociado';

CREATE TABLE Material (
    Id_Producto INT AUTO_INCREMENT PRIMARY KEY
    COMMENT 'Identificador único del producto',
    
    Nombre_Producto VARCHAR(100) NOT NULL UNIQUE
    COMMENT 'Nombre del producto',
    
    Categoria VARCHAR(80) NOT NULL
    COMMENT 'Categoría del producto',
    
    Stock_Actual INT NOT NULL DEFAULT 0
    COMMENT 'Cantidad actual disponible en inventario',
    
    Unidad VARCHAR(30) NOT NULL
    COMMENT 'Unidad de medida del producto (metros, unidades, etc.)',
    
    Stock_Minimo INT NOT NULL DEFAULT 0
     COMMENT 'No puede ser menor a 0',
    
    Stock_Maximo INT NOT NULL DEFAULT 0
    COMMENT 'Cantidad máxima permitida en inventario',
    
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP
     COMMENT 'Fecha de generación del comprobante. Debe ser actual.'

    CHECK (Stock_Minimo >= 0)
    
)
COMMENT 'Tabla que almacena los productos registrados en el sistema';

CREATE TABLE Orden_Produccion (
    Id_Orden INT AUTO_INCREMENT PRIMARY KEY
    COMMENT 'Identificador único de la orden de producción',
    
    Id_Cliente INT NOT NULL
    COMMENT 'Cliente que solicita la orden',
    
    Id_Producto INT NOT NULL
    COMMENT 'Producto a fabricar',
    
    Cantidad INT NOT NULL
      COMMENT 'Cantidad a producir',
    
    Prioridad ENUM('Baja','Media','Alta') NOT NULL DEFAULT 'Media'
    COMMENT 'Nivel de prioridad',
    
    Fecha_Limite DATE NOT NULL
    COMMENT 'La fecha no puede ser anterior al dia vigente',
    
    Descripcion VARCHAR(150) NOT NULL
    COMMENT 'Descripcion del producto',
    
    Estado ENUM('En Proceso','Completada','Cancelada') 
        NOT NULL DEFAULT 'En Proceso'
    
    COMMENT 'Estado de la orden'
    
    CHECK (Cantidad >= 0),
    
    FOREIGN KEY (Id_Cliente) REFERENCES Usuario(Id_Usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (Id_Producto) REFERENCES Material(Id_Producto)
        ON DELETE CASCADE ON UPDATE CASCADE

)
COMMENT 'Tabla que almacena las órdenes de producción';

CREATE TABLE Orden_Material (
    Id_Orden INT NOT NULL
    COMMENT 'Id de la Orden',
    
    Id_Producto INT NOT NULL 
    COMMENT 'Id del producto',
    
    Cantidad_Usada INT NOT NULL 
    COMMENT 'Cantidad usada en la orden',

    PRIMARY KEY (Id_Orden, Id_Producto),

    FOREIGN KEY (Id_Orden) REFERENCES Orden_Produccion(Id_Orden)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (Id_Producto) REFERENCES Material(Id_Producto)
        ON DELETE CASCADE ON UPDATE CASCADE

)
COMMENT 'Tabla puente';

CREATE TABLE Usuario_Orden (
    Id_Usuario INT NOT NULL
    COMMENT 'Id del Usuario',
    
    Id_Orden INT NOT NULL 
    COMMENT 'Id de la Orden',
    
    Funcion VARCHAR(50)
    COMMENT 'Funcionalidad de la orden',

    PRIMARY KEY  (Id_Usuario, Id_Orden),

    FOREIGN KEY (Id_Usuario) REFERENCES Usuario(Id_Usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (Id_Orden) REFERENCES Orden_Produccion(Id_Orden)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Comprobantes (
    Id_Comprobante INT AUTO_INCREMENT PRIMARY KEY 
    COMMENT 'Identificador único del comprobante.',
    
    Id_Usuario INT NOT NULL 
    COMMENT 'Persona que crea el comprobante',
    
    Id_Orden INT NOT NULL 
    COMMENT 'Numero de orden',
    
    Estado ENUM('Entregado','Pendiente') 
        NOT NULL DEFAULT 'Pendiente'
    COMMENT 'Estado del comprobante',
    
    Fecha_Limite DATE DEFAULT CURRENT_TIMESTAMP
    COMMENT 'Fecha de generación del comprobante. No debe ser pasada.',
    

    FOREIGN KEY (Id_Usuario) REFERENCES Usuario(Id_Usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (Id_Orden) REFERENCES Orden_Produccion(Id_Orden)
       ON DELETE CASCADE ON UPDATE CASCADE
)
COMMENT 'Tabla que gestiona los comprobantes generados en el sistema.';
