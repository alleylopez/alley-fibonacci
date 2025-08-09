import 'package:flutter/material.dart';
import 'package:alley_fibonacci/src/switch_surface.dart'; // Adjust the path accordingly

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
          title: const Text('Enter a Number'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Number between 1 and 1000",
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
              child: const Text('Cancel'),
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
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (context) {
            return Row(
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/fibonacci_logo.png',
                    height: 40,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                Text(
                  'Alley Fibonacci${_inputNumber != null ? ': $_inputNumber' : ''}',
                ),
              ],
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Mathematical Concepts'),
            ),
            ListTile(title: const Text('Fibonacci')),
            ListTile(title: const Text("Euler's Constant")),
            ListTile(title: const Text('Pi')),
          ],
        ),
      ),
      body: Center(
        child: SwitchResponsive(number: _inputNumber, activated: _activated),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNumberInputDialog,
        tooltip: 'Enter Number',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
