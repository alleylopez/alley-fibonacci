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
  Map<String, dynamic> _fibonacciMap = {};
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
      // This is a placeholder endpoint. Replace with your actual API.
      final response = await Dio().get(
        'https://dummyjson.com/products/${widget.number}',
      );
      if (response.statusCode == 200) {
        setState(() {
          // Assuming the API returns a map.
          _fibonacciMap = Map<String, dynamic>.from(response.data);
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
    return Container(
      color: Colors.deepOrangeAccent, // Use your palette token here
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : _fibonacciMap.isEmpty
          ? const Center(
              child: Text('Enter a number to see the Fibonacci sequence.'),
            )
          : ListView(
              children: _fibonacciMap.entries.map((entry) {
                return ListTile(title: Text('${entry.key}: ${entry.value}'));
              }).toList(),
            ),
    );
  }
}
