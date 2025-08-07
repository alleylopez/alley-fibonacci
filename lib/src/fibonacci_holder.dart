import 'package:flutter/material.dart';
import 'package:alley_fibonacci/src/switch_surface.dart';

class FibonacciHolder extends StatefulWidget {
  const FibonacciHolder({super.key, required this.title});

  final String title;

  @override
  State<FibonacciHolder> createState() => _FibonacciHolderState();
}

class _FibonacciHolderState extends State<FibonacciHolder> {
  int _inputNumber = 0;

  void _showNumberInputDialog() {
    TextEditingController controller = TextEditingController(
      text: _inputNumber.toString(),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter a Number'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final number = int.tryParse(value);
              if (number != null) {
                _inputNumber = number;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Update the input number to trigger rebuild
                  _inputNumber = int.tryParse(controller.text) ?? 0;
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: Text('Fibonacci Sequence: $_inputNumber'),
      ),
      body: SwitchResponsive(number: _inputNumber),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNumberInputDialog,
        tooltip: 'Input Number',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
