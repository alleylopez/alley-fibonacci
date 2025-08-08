import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class AvrSurface extends StatefulWidget {
  final int? number;
  const AvrSurface({super.key, required this.number});

  @override
  State<AvrSurface> createState() => _AvrSurfaceState();
}

class _AvrSurfaceState extends State<AvrSurface> {
  Map<String, dynamic> _fibonacciMap = {};
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _validateAndFetch();
  }

  @override
  void didUpdateWidget(covariant AvrSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.number != oldWidget.number) {
      if (widget.number == null) {
        setState(() {
          _error = "Invalid input. Please enter only numbers.";
          _fibonacciMap = {};
          _isLoading = false;
        });
      } else {
        _validateAndFetch();
      }
    }
  }

  void _validateAndFetch() {
    if (widget.number == null) {
      return;
    }

    setState(() {
      _isLoading = false;
      _fibonacciMap = {};
      _error = null;
    });

    if (widget.number == 0) {
      setState(() {
        _error =
            'The number cannot be 0. It must be a value between 1 and 1000.';
      });
      return;
    }

    if (widget.number! < 1 || widget.number! > 1000) {
      setState(() {
        _error = 'The number must be in the range of 1 to 1000.';
      });
      return;
    }

    _fetchFibonacci();
  }

  Future<void> _fetchFibonacci() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      assert(
        dotenv.env['API_PATH'] != null,
        'API_PATH is not defined in .env file',
      );
      final response = await Dio().post(
        dotenv.env['API_PATH']!,
        data: {'fibonacci_length': widget.number},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        setState(() {
          _fibonacciMap = Map<String, dynamic>.from(response.data);
        });
      } else {
        setState(() {
          _error =
              'Unexpected error in API response. Code: ${response.statusCode}';
        });
      }
    } on DioException catch (e) {
      String message = 'Network or server error. Please try again.';
      int? statusCode = e.response?.statusCode;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timed out. Please try again later.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (statusCode != null) {
          message = 'Error fetching data (HTTP Code: $statusCode).';
        } else {
          message = 'Unexpected server response error.';
        }
      } else if (e.error is SocketException) {
        message = 'No internet connection.';
      }

      setState(() {
        _error =
            message + (statusCode != null ? ' (Error code: $statusCode)' : '');
      });
      debugPrint('DioException: $e');
    } catch (e) {
      setState(() {
        _error = 'An unexpected error occurred.';
      });
      debugPrint('Generic Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16.0),
      child: Center(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const CircularProgressIndicator(color: Colors.white);
    }
    if (_error != null) {
      return Text(
        _error!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }
    if (_fibonacciMap.isEmpty) {
      return const Text(
        'Enter a number to generate the Fibonacci sequence.',
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      );
    }

    final sequence = _fibonacciMap['sequence'] as List<dynamic>? ?? [];
    return ListView.builder(
      itemCount: sequence.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            sequence[index].toString(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
