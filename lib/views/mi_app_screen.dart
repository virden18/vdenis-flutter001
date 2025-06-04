import 'package:flutter/material.dart';

class MiAppScreen extends StatefulWidget {
  const MiAppScreen({super.key});

  @override
  MiAppScreenState createState() => MiAppScreenState();
}

class MiAppScreenState extends State<MiAppScreen> {
  Color _colorActual = Colors.blue;
  final List<Color> _colores = [Colors.blue, Colors.red, Colors.green];
  int _indiceColor = 0;

  void _cambiarColor() {
    setState(() {
      _indiceColor = (_indiceColor + 1) % _colores.length;
      _colorActual = _colores[_indiceColor];
    });
  }
  
  void _resetColor() {
    setState(() {
      _colorActual = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Volver',
        ),
        title: const Text('Mi App'),
      ),
      body: Center(
        child: Column(          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              color: _colorActual,
              alignment: Alignment.center,
              child: const Text(
                '¡Cambio de color!',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 300,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  ElevatedButton(
                    onPressed: _cambiarColor, 
                    child: const Text('Cambiar Color'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _resetColor, 
                    child: const Text('Resetea Color'),
                  ),
                ],
              ),
            ),
          ],
        ),      
      ),
    );
  }
}