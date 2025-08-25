import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final String id;
  final List<ProductoPedido> productos;
  final double total;
  final String estado;
  final DateTime fecha;

  Pedido({
    required this.id,
    required this.productos,
    required this.total,
    required this.estado,
    required this.fecha,
  });

  factory Pedido.fromMap(Map<String, dynamic> data, String documentId) {
    var productosList = (data['productos'] as List<dynamic>? ?? [])
        .map((item) => ProductoPedido.fromMap(item))
        .toList();
    return Pedido(
      id: documentId,
      productos: productosList,
      total: (data['total'] ?? 0).toDouble(),
      estado: data['estado'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productos': productos.map((p) => p.toMap()).toList(),
      'total': total,
      'estado': estado,
      'fecha': fecha,
    };
  }
}

class ProductoPedido {
  final String productoId;
  final int cantidad;

  ProductoPedido({required this.productoId, required this.cantidad});

  factory ProductoPedido.fromMap(Map<String, dynamic> data) {
    return ProductoPedido(
      productoId: data['productoId'] ?? '',
      cantidad: data['cantidad'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productoId': productoId,
      'cantidad': cantidad,
    };
  }
}
