import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// The white surface component
class AvrSurface extends StatefulWidget {
  final int number;
  const AvrSurface({super.key, required this.number});

  @override
  State<AvrSurface> createState() => _AvrSurfaceState();
}

class _AvrSurfaceState extends State<AvrSurface> {
  List<dynamic> _fibonacciList = [];
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
  void didUpdateWidget(covariant AvrSurface oldWidget) {
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
          // Assuming the API returns a list under a 'data' key.
          // Adjust based on your actual API response structure.
          _fibonacciList = [response.data];
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
      color: Colors.amber, // Use your palette token here
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : _fibonacciList.isEmpty
          ? const Center(
              child: Text('Enter a number to see the Fibonacci sequence.'),
            )
          : ListView.builder(
              itemCount: _fibonacciList.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_fibonacciList[index].toString()));
              },
            ),
    );
  }
}
