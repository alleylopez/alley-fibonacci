import 'package:alley_fibonacci/src/config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BadSurface extends StatefulWidget {
  final int? number;

  const BadSurface({Key? key, required this.number}) : super(key: key);

  @override
  State<BadSurface> createState() => _BadSurfaceState();
}

class _BadSurfaceState extends State<BadSurface> {
  List<dynamic> _fibonacciList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.number != null) {
      _fetchFibonacci(widget.number!);
    }
  }

  @override
  void didUpdateWidget(covariant BadSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.number != oldWidget.number && widget.number != null) {
      _fetchFibonacci(widget.number!);
    }
  }

  Future<void> _fetchFibonacci(int number) async {
    setState(() {
      _isLoading = true;
      _fibonacciList = [];
    });

    try {
      final response = await Dio().post(
        apiPath,
        data: {'fibonacci_length': number},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      _fibonacciList = response.data!['sequence'];

      setState(() {
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        Exception('FATAL ERROR (BAD): API call failed. Intentional crash.'),
        stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Intentionally crash if the input is invalid, which is bad practice.
    if (widget.number == null) {
      throw ArgumentError(
        'FATAL ERROR (BAD): Null or non-numeric input. Intentional crash.',
      );
    }
    if (widget.number! <= 0 || widget.number! > 1000) {
      throw RangeError(
        'FATAL ERROR (BAD): Number out of range (1-1000). Intentional crash.',
      );
    }

    return Container(
      color: Colors.red[300],
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _fibonacciList.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  'Index: $index, Value: ${_fibonacciList[index]}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
    );
  }
}
