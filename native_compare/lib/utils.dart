import 'package:flutter/cupertino.dart';

@immutable
class ExampleButton extends StatelessWidget {
  const ExampleButton({super.key, required this.onTap});

  const ExampleButton.builder(
    BuildContext _,
    this.onTap, {
    super.key,
  });

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: CupertinoColors.systemGreen,
        onPressed: onTap,
        pressedOpacity: 1,
        minimumSize: Size(
          MediaQuery.textScalerOf(context).scale(34),
          MediaQuery.textScalerOf(context).scale(34),
        ),
        child: const Text('Button'),
      );
}
