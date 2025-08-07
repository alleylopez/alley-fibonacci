import 'package:alley_fibonacci/src/avr_surface/avr_surface.dart';
import 'package:alley_fibonacci/src/bad_surface/bad_surface.dart';
import 'package:flutter/material.dart';

class SwitchResponsive extends StatefulWidget {
  /// Width breakpoint at which to switch layout
  static const double _breakpoint = 700;

  final int number;

  const SwitchResponsive({super.key, required this.number});

  @override
  _SwitchResponsiveState createState() => _SwitchResponsiveState();
}

class _SwitchResponsiveState extends State<SwitchResponsive> {
  bool _showLeftChild = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= SwitchResponsive._breakpoint) {
          // Desktop: show both children side by side with 3.5% margins on leftChild
          return SizedBox(
            width: constraints.maxWidth,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor:
                          0.86, // 86% del ancho disponible = 14% de márgenes totales
                      child: AvrSurface(number: widget.number),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.86,
                      child: BadSurface(number: widget.number),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Tablet/Mobile: center leftChild in white surface with switch button
          return Stack(
            children: [
              Center(
                child: _showLeftChild
                    ? AvrSurface(number: widget.number)
                    : BadSurface(number: widget.number),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showLeftChild = !_showLeftChild;
                      });
                    },
                    child: Text(
                      _showLeftChild
                          ? 'Switch to Bad View'
                          : 'Switch to AVR View',
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
