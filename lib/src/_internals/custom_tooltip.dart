import 'package:flutter/material.dart';

/// A custom tooltip that doesn't reserve space in the layout
class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    required this.message,
    required this.child,
    this.waitDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(seconds: 2),
    super.key,
  });

  final String message;
  final Widget child;
  final Duration waitDuration;
  final Duration showDuration;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + size.width / 2,
        top: offset.dy - 32,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(widget.showDuration, () {
      if (!_isHovering) {
        _removeTooltip();
      }
    });
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isHovering = true;
        Future.delayed(widget.waitDuration, () {
          if (_isHovering && mounted) {
            _showTooltip();
          }
        });
      },
      onExit: (_) {
        _isHovering = false;
        _removeTooltip();
      },
      child: widget.child,
    );
  }
}
