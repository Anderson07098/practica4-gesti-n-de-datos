class Producto {
  final String id;
  final String nombre;
  final double precio;
  final int stock;
  final String imagenUrl;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.imagenUrl,
  });

  factory Producto.fromMap(Map<String, dynamic> data, String documentId) {
    return Producto(
      id: documentId,
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      imagenUrl: data['imagenUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'imagenUrl': imagenUrl,
    };
  }
}
