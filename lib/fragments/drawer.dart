import 'package:flutter/material.dart';
import 'package:preset/preset.dart';
import 'package:text2/text2.dart';

class MainDrawer extends StatelessWidget {
  //...Fields
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cloudchain',
                  style: context.glyphs.foreground.titleLarge,
                ),
                Text2(
                  '[italic](Brian)',
                  style: context.glyphs.foreground.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
