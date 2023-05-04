library pinata.note_read;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preset/preset.dart';
import 'package:qp_xt_flutter/qp_xt.dart';
import 'package:text2/text2.dart';

import '../models/doc.dart';

part '../utils/note_read.dart';

class NoteRead extends StatefulWidget {
  //...Fields
  final NoteReadSys reader;

  const NoteRead({super.key, required this.reader});

  @override
  State<NoteRead> createState() => _NoteReadState();
}

class _NoteReadState extends State<NoteRead>
    with //
        SingleTickerProviderStateMixin {
  //...Methods
  @override
  Widget build(BuildContext context) {
    //...
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatefulBuilder(builder: readTitle),
            StatefulBuilder(builder: readContent),
          ],
        );
      },
    );
  }

  //...Builders
  Widget readTitle(BuildContext context, setState) {
    //...
    NoteReadSys(head: setState);
    return AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      toolbarHeight: 40.0,
      leadingWidth: 48.0,
      scrolledUnderElevation: 16.0,
      backgroundColor: context.colors.ascent,
      leading: const Icon(Icons.file_open_outlined),
      title: Text(widget.reader.head),
    );
  }

  Widget readContent(BuildContext context, setState) {
    //...
    NoteReadSys(body: setState);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.data.size.height * .65,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AnimatedSize(
              curve: Curves.easeInOutCubicEmphasized,
              alignment: Alignment.bottomCenter,
              duration: const Duration(milliseconds: 800),
              child: Text(widget.reader.body),
            ),
            const SizedBox(height: 16),
            StatefulBuilder(builder: readDetails),
          ],
        ),
      ),
    );
  }

  Widget readDetails(BuildContext context, setState) {
    //...
    NoteReadSys(xtra: setState);
    return Container(
      padding: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.ascent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text2((widget.reader.date.literalDate)),
          const SizedBox(height: 4),
          Text2('0x${widget.reader.address}', maxLines: 1),
          const SizedBox(height: 4),
          Text2('SN${widget.reader.serial}', maxLines: 1),
        ],
      ),
    );
  }

  //...Callbacks
  void copyAddress() {
    //...
    Clipboard.setData(
      ClipboardData(text: '0x${widget.reader.address}'),
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address copied'),
        ),
      );
    });
  }

  @override
  void dispose() {
    //...
    widget.reader.dispose();
    super.dispose();
  }
}

typedef Computation = Function({
  String? title,
  String? content,
  Document? doc,
});
