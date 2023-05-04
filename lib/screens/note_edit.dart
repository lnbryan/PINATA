library pinata.note_edit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinata/pinata.dart';
import 'package:preset/preset.dart';

import '../models/doc.dart';
import 'files.dart';

part '../utils/note_edit.dart';

class NoteEdit extends StatefulWidget {
  //...Fields
  final Checkout? checkout;

  const NoteEdit({
    super.key,
    this.checkout,
  });

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit>
    with //
        SingleTickerProviderStateMixin {
  //...Fields
  final editor = NoteEditSys();

  //...Methods
  @override
  Widget build(BuildContext context) {
    //...
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: editTitle),
              Builder(builder: editContent),
              Builder(builder: editActions),
            ],
          ),
        );
      },
    );
  }

  //...Builders
  Widget editTitle(BuildContext context) {
    //...
    return TextField(
      controller: editor._head,
      minLines: 1,
      maxLines: 1,
      maxLength: 40,
      textInputAction: TextInputAction.next,
    );
  }

  Widget editContent(BuildContext context) {
    //...
    return TextField(
      controller: editor._body,
      minLines: 3,
      maxLines: 15,
      maxLength: 25000,
      onChanged: (text) => editor.canSave = text.length > 8,
      spellCheckConfiguration: SpellCheckConfiguration(
        misspelledTextStyle: context.glyphs.error.bodySmall,
        spellCheckService: DefaultSpellCheckService(),
      ),
    );
  }

  Widget editActions(BuildContext context) {
    //...
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: pasteFromClipboard,
            child: const Text('Paste'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: selectAFile,
            child: const Icon(Icons.folder),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: mintData,
            statesController: editor._save,
            child: const Text('Mint'),
          ),
        ],
      ),
    );
  }

  //...Callbacks
  void mintData() {
    //...
    final title = editor.body.substring(0, 8);
    //...
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: context.colors.foreground,
          ),
        );
      },
    );
    Pinata.test.pinJson(
      {'title': editor.head, 'content': editor.body},
      name: editor.head.isEmpty ? title : editor.head,
    ).then(checkout);
  }

  void selectAFile() {
    //...
    Navigator.of(context).push(
      MyFiles(
        key: const Key('files'),
        editor: editor,
      ).route,
    );
  }

  // void scanAddress() {
  //   //...
  //   showDialog(
  //     context: context,
  //     builder: (context) => Scan(
  //       computation: compute,
  //     ),
  //   );
  // }

  void pasteFromClipboard() {
    //...
    Clipboard.getData('text/plain').then((value) {
      final text = editor.head;
      final init = editor.body.trim().isEmpty ? '' : '\n';
      editor.compute(body: '$text$init${value?.text ?? ''}');
    });
  }

  void checkout(PinLink value) {
    //...
    if (value.isDuplicate ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This doc already exist'),
        ),
      );
    }
    Navigator.of(context).pop();
    widget.checkout?.call(() {});
  }
}

typedef Checkout = Function(Function() fn);

typedef Computation = Function({
  String? title,
  String? content,
  Document? doc,
});
