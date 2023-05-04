import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinata/pinata.dart';
import 'package:preset/preset.dart';
import 'package:qp_xt_flutter/qp_xt.dart';
import 'package:text2/text2.dart';

import '../screens/notes.dart';

class Document extends StatelessWidget {
  //...
  final DocLoader? loader;

  final Pin pin;

  const Document({
    super.key,
    this.loader,
    required this.pin,
  });

  //...Fields
  @override
  Widget build(BuildContext context) {
    //...
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.ascent,
          width: .1,
        ),
        // borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => loader?.call(context, this),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(builder: upper),
                const SizedBox(height: 6.0),
                Builder(builder: lower),
                const SizedBox(height: 0.0),
                Builder(builder: address),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget upper(BuildContext context) {
    //...
    final ext = RegExp(r'(\.\w+)+$');
    final name = pin.name.replaceFirst(ext, '');
    //...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.contains(RegExp(r'[)(]')))
          Text(
            name.toSentenceCase(),
            style: context.glyphs.foreground.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (!name.contains(RegExp(r'[)(]')))
          Text2(
            '[bold](${name.toSentenceCase()})',
            style: context.glyphs.foreground.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget lower(BuildContext context) {
    //...
    return Row(
      children: [
        Text2(
          pin.datePinned.format('%Day\t\t\t%d/%MM/%yyyy'),
          style: context.glyphs.foreground.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Text2(
          pin.datePinned.format('[thin](%hh:%mm %a)'),
          style: context.glyphs.foreground.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget address(BuildContext context) {
    //...
    return Row(
      children: [
        Expanded(
          child: Text2(
            '[size:x.85](0x${pin.address})',
            style: context.glyphs.subtle.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => copyAddress(context),
          icon: const Icon(Icons.copy, size: 16),
        )
      ],
    );
  }

  void copyAddress(BuildContext context) {
    final address = pin.address;
    Clipboard.setData(
      ClipboardData(text: '0x$address'),
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address copied')),
      );
    });
  }
}
