import 'dart:io';

import 'package:flutter/material.dart';
import 'package:preset/preset.dart';

import '../screens/note_edit.dart';

class MyFile extends StatefulWidget {
  //...Fields
  final String path;
  final String? name;
  final String extension;
  final bool isFolder;
  final FileSystemEntity file;
  final FileLoader loader;
  final NoteEditSys editor;

  const MyFile({
    super.key,
    required this.path,
    required this.name,
    required this.extension,
    required this.isFolder,
    required this.file,
    required this.loader,
    required this.editor,
  });

  @override
  State<MyFile> createState() => _MyFileState();
}

class _MyFileState extends State<MyFile>
    with //
        TickerProviderStateMixin {
  //...Methods
  @override
  Widget build(BuildContext context) {
    //...
    return InkWell(
      onTap: click,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Row(
          children: [
            Builder(builder: icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.name ?? widget.path,
                maxLines: 1,
                softWrap: false,
                textWidthBasis: TextWidthBasis.longestLine,
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.isFolder)
              const Icon(
                Icons.chevron_right,
                size: 16,
              ),
            if (!widget.isFolder) Builder(builder: tag),
          ],
        ),
      ),
    );
  }

  Widget icon(BuildContext context) {
    //...
    if (widget.isFolder) return const Icon(Icons.folder);
    final path = iconMap[widget.extension.toLowerCase()];
    return Image.asset(
      path ?? 'assets/file.png',
      color: context.colors.foreground,
      height: 24,
      width: 24,
    );
  }

  Widget tag(BuildContext context) {
    //...
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.colors.ascent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        widget.extension.toUpperCase(),
        style: context.glyphs.onAscent.labelSmall,
      ),
    );
  }

  click() {
    if (widget.isFolder) {
      widget.loader(widget.file as Directory);
    } else {
      (widget.file as File).readAsString().then((value) {
        widget.editor.compute(head: widget.name, body: value);
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }
}

const iconMap = {
  'json': 'assets/json.png',
  'html': 'assets/html.png',
  'htm': 'assets/html.png',
  'xml': 'assets/html.png',
  'txt': 'assets/txt.png',
  'css': 'assets/src.png',
  'java': 'assets/java.png',
  'py': 'assets/py.png',
  'md': 'assets/md.png',
};

typedef FileLoader = bool Function(Directory? dir, {bool r});
