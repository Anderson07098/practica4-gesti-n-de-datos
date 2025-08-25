import 'package:flutter/material.dart';
import 'models/pedido.dart';
import 'services/pedido_service.dart';

class HistorialPedidosPage extends StatefulWidget {
  const HistorialPedidosPage({super.key});

  @override
  State<HistorialPedidosPage> createState() => _HistorialPedidosPageState();
}

class _HistorialPedidosPageState extends State<HistorialPedidosPage> {
  final PedidoService _pedidoService = PedidoService();
  List<Pedido> _pedidos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final pedidos = await _pedidoService.getPedidos();
    setState(() {
      _pedidos = pedidos;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Pedidos')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? const Center(child: Text('No hay pedidos realizados.'))
              : ListView.builder(
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = _pedidos[index];
                    return ListTile(
                      title: Text('Pedido #${pedido.id}'),
                      subtitle: Text('Estado: ${pedido.estado}\nFecha: ${pedido.fecha}'),
                      trailing: Text('Total: ${pedido.total.toStringAsFixed(2)}'),
                    );
                  },
                ),
    );
  }
}
