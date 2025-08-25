// ...existing code...
import '../models/pedido.dart';

class CarritoProvider {
  final List<ProductoPedido> _items = [];

  List<ProductoPedido> get items => List.unmodifiable(_items);

  void agregarProducto(String productoId) {
    final index = _items.indexWhere((item) => item.productoId == productoId);
    if (index >= 0) {
      _items[index] = ProductoPedido(
        productoId: productoId,
        cantidad: _items[index].cantidad + 1,
      );
    } else {
      _items.add(ProductoPedido(productoId: productoId, cantidad: 1));
    }
  }

  void quitarProducto(String productoId) {
    final index = _items.indexWhere((item) => item.productoId == productoId);
    if (index >= 0) {
      if (_items[index].cantidad > 1) {
        _items[index] = ProductoPedido(
          productoId: productoId,
          cantidad: _items[index].cantidad - 1,
        );
      } else {
        _items.removeAt(index);
      }
    }
  }

  void limpiar() {
    _items.clear();
  }
}

// Agregar dependencias de FlutterFire y configurar Firebase
// flutter pub add flutterfire_cli
// dart run flutterfire_cli configure
