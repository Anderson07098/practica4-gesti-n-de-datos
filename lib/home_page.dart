import 'package:flutter/material.dart';
import 'models/producto.dart';
import 'models/pedido.dart';
import 'services/producto_service.dart';
import 'services/pedido_service.dart';
import 'services/carrito_provider.dart';
import 'historial_pedidos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductoService _productoService = ProductoService();
  final PedidoService _pedidoService = PedidoService();
  final CarritoProvider _carrito = CarritoProvider();
  List<Producto> _productos = [
    Producto(
      id: '1',
      nombre: 'Set Sakura Phantom Assassin',
      precio: 1200,
      stock: 5,
      imagenUrl: 'assets/images/phantom_assassin.png',
    ),
    Producto(
      id: '2',
      nombre: 'Set Immortal Pudge',
      precio: 1500,
      stock: 3,
      imagenUrl: 'assets/images/pudge.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final productos = await _productoService.getProductos();
    setState(() {
      _productos = productos;
    });
  }

  void _agregarAlCarrito(String productoId) {
    setState(() {
      _carrito.agregarProducto(productoId);
    });
  }

  void _quitarDelCarrito(String productoId) {
    setState(() {
      _carrito.quitarProducto(productoId);
    });
  }

  double _calcularTotal() {
    double total = 0;
    for (var item in _carrito.items) {
      final producto = _productos.firstWhere(
        (p) => p.id == item.productoId,
  orElse: () => Producto(id: '', nombre: '', precio: 0, stock: 0, imagenUrl: ''),
      );
      total += producto.precio * item.cantidad;
    }
    return total;
  }

  void _mostrarCarrito() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Carrito de compras', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            if (_carrito.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('El carrito está vacío'),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _carrito.items.length,
                  itemBuilder: (context, index) {
                    final item = _carrito.items[index];
                    final producto = _productos.firstWhere(
                      (p) => p.id == item.productoId,
                      orElse: () => Producto(id: '', nombre: '', precio: 0, stock: 0, imagenUrl: ''),
                    );
                    return ListTile(
                      title: Text(producto.nombre),
                      subtitle: Text('Cantidad: ${item.cantidad} | Precio: ${producto.precio.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _quitarDelCarrito(producto.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _agregarAlCarrito(producto.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: ${_calcularTotal().toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                  ElevatedButton.icon(
                    onPressed: _carrito.items.isEmpty ? null : () {
                      Navigator.pop(context);
                      _realizarPedido();
                    },
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: const Text('Realizar Pedido'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _realizarPedido() async {
    if (_carrito.items.isEmpty) return;
    final pedido = Pedido(
      id: '',
      productos: _carrito.items,
      total: 0, // Puedes calcular el total sumando los precios
      estado: 'pendiente',
      fecha: DateTime.now(),
    );
    await _pedidoService.addPedido(pedido);
    if (!mounted) return;
    setState(() {
      _carrito.limpiar();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Pedido realizado!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial de pedidos',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistorialPedidosPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Ver carrito',
            onPressed: _mostrarCarrito,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _productos.length,
        itemBuilder: (context, index) {
          final producto = _productos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                  producto.imagenUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(producto.nombre),
              subtitle: Text('Precio: ${producto.precio.toStringAsFixed(2)} | Stock: ${producto.stock}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => _agregarAlCarrito(producto.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
