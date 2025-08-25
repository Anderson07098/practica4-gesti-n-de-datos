import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/producto.dart';

class ProductoService {
  final CollectionReference productosRef = FirebaseFirestore.instance.collection('productos');

  Future<List<Producto>> getProductos() async {
    final snapshot = await productosRef.get();
    return snapshot.docs.map((doc) => Producto.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addProducto(Producto producto) async {
    await productosRef.add(producto.toMap());
  }

  Future<void> updateProducto(Producto producto) async {
    await productosRef.doc(producto.id).update(producto.toMap());
  }

  Future<void> deleteProducto(String id) async {
    await productosRef.doc(id).delete();
  }
}
