from flask import Flask, jsonify, request, send_from_directory
import mysql.connector
from flask_cors import CORS
import jwt
import datetime
from dotenv import load_dotenv
from os import environ

load_dotenv()

app = Flask(__name__)
CORS(app)
host = environ.get('DB_HOST')
port = environ.get('DB_PORT')
dbname = environ.get('DB_NAME')
username = environ.get('DB_USERNAME')
password = environ.get('DB_PASSWORD')

SECRET_KEY = environ.get('SECRET_KEY')


def get_connection():
    conn = mysql.connector.connect(
        host=host,
        port=port,
        user=username,
        password=password,
        database=dbname
    )
    return conn


app = Flask(__name__, static_folder='static', static_url_path='')


@app.route('/')
def serve():
    return send_from_directory(app.static_folder, 'index.html')


# Ruta para los archivos estáticos
@app.route('/<path:path>')
def static_files(path):
    return send_from_directory(app.static_folder, path)


@app.get('/api/eventos')
def get_eventos():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Eventos')
    eventos = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(eventos)


@app.post('/api/login')
def login():
    conn = get_connection()
    cursor = conn.cursor()
    user = request.get_json()
    print(f"Usuario: {user}")
    username = user['username']
    password = user['password']
    cursor.execute(f"SELECT id, nombre_usuario FROM Usuarios WHERE nombre_usuario = %s AND contrasena = %s",
                   (username, password))
    loggedUser = cursor.fetchone()
    if loggedUser is None:
        return jsonify({'message': 'Usuario o contraseña incorrecta'})

    userId = loggedUser[0]
    username = loggedUser[1]

    # Generar token JWT
    token = jwt.encode(
        {
            'userId': userId,
            'username': username,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
        },
        SECRET_KEY,
        algorithm="HS256"
    )

    cursor.close()
    conn.close()

    return jsonify({'token': token, 'userId': userId, 'username': username})


@app.post('/api/registro')
def registro():
    conn = get_connection()
    cursor = conn.cursor()
    user = request.get_json()
    print(f"Usuario: {user}")
    username = user['nombreUsuario']
    correo = user['correoElectronico']
    password = user['contrasena']
    cursor.execute(f"INSERT INTO Usuarios (nombre_usuario, correo_electronico, contrasena) VALUES (%s, %s, %s)",
                   (username, correo, password))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Usuario registrado exitosamente'})


@app.post('/api/search')
def search():
    conn = get_connection()
    cursor = conn.cursor()
    search = request.get_json()
    searchValue = search['searchInput']
    print(searchValue)
    searchPattern = f"%{searchValue}%"
    cursor.execute("""
        SELECT *
        FROM (
            SELECT id, nombre, descripcion, precio, 'productos' AS fuente
            FROM Productos
            WHERE nombre LIKE %s
            UNION ALL
            SELECT id, nombre, descripcion, precio, 'servicios' AS fuente
            FROM Servicios
            WHERE nombre LIKE %s
        ) AS combinacion;
    """, (searchPattern, searchPattern))  # Pasar los parámetros como una tupla
    searchResults = cursor.fetchall()
    print(f"Resultado de la busqueda: {searchResults}")
    cursor.close()
    conn.close()
    return jsonify(searchResults)


@app.post('/api/confirmaciones')
def confirmaciones():
    conn = get_connection()
    cursor = conn.cursor()
    confirmaciones = request.get_json()
    print(f"Confirmaciones: {confirmaciones}")
    name = confirmaciones['nombre']
    apellido = confirmaciones['apellido']
    correo = confirmaciones['email']
    eventoId = confirmaciones['eventoId']
    descuentoProductos = confirmaciones['descuentoProductos']
    descuentoServicios = confirmaciones['descuentoServicios']
    productos = confirmaciones['productos']
    print(
        f"Datos: {name} - {apellido} - {correo} - {eventoId} - {descuentoProductos} - {descuentoServicios}  P/S: {productos}")
    cursor.execute(f"INSERT INTO Clientes (nombres, apellidos, correo_electronico) VALUES (%s, %s, %s)",
                   (name, apellido, correo))
    conn.commit()
    # Obtener el id del cliente recién insertado
    cursor.execute("SELECT LAST_INSERT_ID()")
    clienteId = cursor.fetchone()[0]
    print(f"Id del cliente: {clienteId}")

    cursor.execute(
        f"INSERT INTO Confirmaciones (evento_id, cliente_id, descuento_servicio, descuento_producto) VALUES (%s, %s, %s, %s)",
        (eventoId, clienteId, descuentoServicios, descuentoProductos))
    conn.commit()
    # Obtener el id de la confirmación de evento recién insertada
    cursor.execute("SELECT LAST_INSERT_ID()")
    confirmacionEventoId = cursor.fetchone()[0]
    print(f"Id de la confirmación de evento: {confirmacionEventoId}")

    for producto in productos:
        if producto['fuente'] == 'productos':
            cursor.execute(f"INSERT INTO Confirmaciones_Productos (confirmacion_id, producto_id) VALUES (%s, %s)",
                           (confirmacionEventoId, producto['id']))
            conn.commit()
        else:
            cursor.execute(f"INSERT INTO Confirmaciones_Servicios (confirmacion_id, servicio_id) VALUES (%s, %s)",
                           (confirmacionEventoId, producto['id']))
            conn.commit()

    cursor.close()
    conn.close()
    return jsonify({'message': 'Confirmación registrada exitosamente'})


@app.get('/api/confirmaciones')
def get_confirmaciones():
    conn = get_connection()
    cursor = conn.cursor()
    query = """
    SELECT
    c.id AS confirmacion_id,
    cli.nombres AS cliente_nombres,
    cli.apellidos AS cliente_apellidos,
    cli.correo_electronico AS cliente_correo,
    e.nombre AS evento_nombre,
    e.fecha AS evento_fecha,
    c.fecha_confirmacion,
    c.descuento_servicio,
    c.descuento_producto,
    GROUP_CONCAT(DISTINCT p.nombre ORDER BY p.nombre ASC SEPARATOR ', ') AS productos,
    GROUP_CONCAT(DISTINCT s.nombre ORDER BY s.nombre ASC SEPARATOR ', ') AS servicios
FROM
    Confirmaciones c
JOIN
    Clientes cli ON c.cliente_id = cli.id
JOIN
    Eventos e ON c.evento_id = e.id
LEFT JOIN
    Confirmaciones_Productos cp ON c.id = cp.confirmacion_id
LEFT JOIN
    Productos p ON cp.producto_id = p.id
LEFT JOIN
    Confirmaciones_Servicios cs ON c.id = cs.confirmacion_id
LEFT JOIN
    Servicios s ON cs.servicio_id = s.id
GROUP BY
    c.id, cli.nombres, cli.apellidos, cli.correo_electronico, cli.telefono,
    e.nombre, e.fecha, c.fecha_confirmacion, c.descuento_servicio, c.descuento_producto;"""
    cursor.execute(query)
    confirmaciones = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(confirmaciones)


@app.get('/api/productos')
def get_productos():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Productos')
    productos = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(productos)


@app.get('/api/servicios')
def get_servicios():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Servicios')
    servicios = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(servicios)


@app.post('/api/productos/crear')
def crear_producto():
    conn = get_connection()
    cursor = conn.cursor()
    producto = request.get_json()
    print(f"Producto: {producto}")
    nombre = producto['nombre']
    descripcion = producto['descripcion']
    precio = producto['precio']
    cursor.execute(f"INSERT INTO Productos (nombre, descripcion, precio) VALUES (%s, %s, %s)",
                   (nombre, descripcion, precio))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Producto registrado exitosamente'})


@app.post('/api/servicios/crear')
def crear_servicio():
    conn = get_connection()
    cursor = conn.cursor()
    servicio = request.get_json()
    print(f"Servicio: {servicio}")
    nombre = servicio['nombre']
    descripcion = servicio['descripcion']
    precio = servicio['precio']
    cursor.execute(f"INSERT INTO Servicios (nombre, descripcion, precio) VALUES (%s, %s, %s)",
                   (nombre, descripcion, precio))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Servicio registrado exitosamente'})


if __name__ == '__main__':
    app.run()
