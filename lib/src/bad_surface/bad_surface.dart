import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// The blue surface component
class BadSurface extends StatefulWidget {
  final int number;
  const BadSurface({super.key, required this.number});

  @override
  State<BadSurface> createState() => _BadSurfaceState();
}

class _BadSurfaceState extends State<BadSurface> {
  List<int> _sequence = [];
  int _total = 0;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.number > 0) {
      _fetchFibonacci();
    }
  }

  @override
  void didUpdateWidget(covariant BadSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.number != oldWidget.number && widget.number > 0) {
      _fetchFibonacci();
    }
  }

  Future<void> _fetchFibonacci() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await Dio().post(
        'https://api-fibonacci-654848717191.southamerica-east1.run.app/fibonacci',
        data: {'fibonacci_length': widget.number},
      );
      if (response.statusCode == 200) {
        setState(() {
          _total = response.data['total'] ?? 0;
          _sequence = List<int>.from(response.data['sequence'] ?? []);
        });
      } else {
        setState(() {
          _error = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('Total: $_total'),
      ),
      body: Container(
        color: Colors.deepOrangeAccent,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              )
            : _sequence.isEmpty
            ? const Center(
                child: Text('Enter a number to see the Fibonacci sequence.'),
              )
            : ListView.builder(
                itemCount: _sequence.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('${_sequence[index]}'));
                },
              ),
      ),
    );
  }
}
