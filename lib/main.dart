import 'package:flutter/material.dart';
import 'package:preset/preset.dart';
import 'package:text2/text2.dart';

import 'screens/notes.dart';

void main() {
  runApp(const Cloudchain());
}

class Cloudchain extends StatelessWidget {
  //...Fields
  const Cloudchain({super.key});

  @override
  Widget build(BuildContext context) {
    //...
    return PresetApp(
      title: 'Cloudchain',
      presets: const {
        ColorPreset(
          swatch: Colors.blueGrey,
          foreground: Color(0xffcdddea),
          background: Color(0xff15222a),
          primary: Color(0xff0e3752),
          secondary: Color(0xffc9dcec),
          ascent: Color(0xff194867),
          success: Color(0xff9deaaa),
          error: Color(0xffe59b9b),
          warning: Color(0xffd5c28b),
          tint: Color(0x55465470),
          shade: Color(0x550A1018),
        ),
        GlyphPreset.redmond,
      },
      adoption: (context) {
        return PresetAdapter(
          updateTheme: (theme) {
            return theme.copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: theme.elevatedButtonTheme.style?.copyWith(
                  minimumSize: const MaterialStatePropertyAll(Size.square(36)),
                  iconSize: const MaterialStatePropertyAll(24.0),
                ),
              ),
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                alignLabelWithHint: true,
                labelStyle: context.glyphs.primal.titleSmall,
                counterStyle: context.glyphs.primal.bodySmall,
                floatingLabelStyle: context.glyphs.foreground.titleSmall,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: context.colors.primal),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: context.colors.foreground),
                ),
              ),
            );
          },
          extensions: {
            DefaultMarkupTheme(),
          },
        );
      },
      home: const Dashboard(),
    );
  }
}
