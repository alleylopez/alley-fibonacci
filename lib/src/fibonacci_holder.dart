import 'package:flutter/material.dart';
import 'package:alley_fibonacci/src/switch_surface.dart'; // Ajusta según ruta correcta

class FibonacciHolder extends StatefulWidget {
  const FibonacciHolder({super.key, required this.title});

  final String title;

  @override
  State<FibonacciHolder> createState() => _FibonacciHolderState();
}

class _FibonacciHolderState extends State<FibonacciHolder> {
  int? _inputNumber;
  bool _activated = false; 

  void _showNumberInputDialog() {
    TextEditingController controller = TextEditingController(
      text: _inputNumber?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingrese un Número'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Número entre 1 y 1000",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final input = controller.text;
                final number = int.tryParse(input);

                setState(() {
                  _inputNumber = number;
                  _activated = true; 
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Fibonacci: ${_inputNumber ?? 'N/A'}'),
      ),
      body: Center(
        child: SwitchResponsive(
          number: _inputNumber,
          activated: _activated, 
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNumberInputDialog,
        tooltip: 'Ingresar Número',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
