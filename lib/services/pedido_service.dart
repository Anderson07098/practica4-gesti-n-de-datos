import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pedido.dart';

class PedidoService {
  final CollectionReference pedidosRef = FirebaseFirestore.instance.collection('pedidos');

  Future<List<Pedido>> getPedidos() async {
    final snapshot = await pedidosRef.get();
    return snapshot.docs.map((doc) => Pedido.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addPedido(Pedido pedido) async {
    await pedidosRef.add(pedido.toMap());
  }

  Future<void> updatePedido(Pedido pedido) async {
    await pedidosRef.doc(pedido.id).update(pedido.toMap());
  }

  Future<void> deletePedido(String id) async {
    await pedidosRef.doc(id).delete();
  }
}
