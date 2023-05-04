library files.search;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:preset/preset.dart';

import '../models/file.dart';
import 'note_edit.dart';

part '../utils/files_search.dart';

class FileSearch extends StatefulWidget {
  //...Fields
  final String query;
  final Directory? directory;
  final NoteEditSys editor;

  const FileSearch({
    super.key,
    this.query = '',
    this.directory,
    required this.editor,
  });

  static FileSearchSys sys({
    required Directory? directory,
    required NoteEditSys editor,
  }) {
    //...
    return FileSearchSys(
      directory: directory,
      editor: editor,
    );
  }

  @override
  State<FileSearch> createState() => _FileSearchState();
}

class _FileSearchState extends State<FileSearch> {
  //...
  late ValueNotifier<List<MyFile>> _files;
  StreamSubscription? _query;

  //...Methods
  @override
  void initState() {
    //...
    _files = ValueNotifier([]);
    _files.addListener(() => setState(() {}));
    loadFrom(widget.directory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //...
    return Stack(
      alignment: Alignment.center,
      children: [
        ListView.builder(
          itemBuilder: file, //...file
          itemCount: _files.value.length,
          padding: const EdgeInsets.symmetric(
            vertical: 4,
          ),
        ),
        if (_files.value.isEmpty)
          Text(
            'Nothing to see here',
            style: context.glyphs.subtle.labelLarge,
          ),
      ],
    );
  }

  Widget file(BuildContext context, index) {
    //...
    index as int;
    //...
    return _files.value[index];
  }

  bool loadFrom(Directory? dir, {bool r = true}) {
    //...
    final files = <MyFile>[];
    if (dir == null) return false;
    check(String element) => element.isNotEmpty;
    query(MyFile f) => f.path.contains(widget.query);
    const li = 'json, txt, js, html, htm, md, xml,'
        ' css, php, py, cp, rtf, ttf, otf, doc, ';
    //...
    _query?.cancel();
    _query = dir.list(recursive: true).listen(
      (file) {
        if (file is Directory) return;
        if (files.length > 50) _query?.pause();
        final pathAndExt = RegExp(r'(.+)\.(\w+)$');
        final name = file.uri.pathSegments.lastWhere(check);
        final match = pathAndExt.firstMatch(name.toLowerCase());
        final extension = match?.group(2) ?? 'unknown';
        final model = MyFile(
          path: file.path,
          name: file.path.replaceFirst(dir.parent.path, ''),
          isFolder: file is Directory,
          loader: loadFrom,
          editor: widget.editor,
          extension: extension,
          file: file,
        );
        if (li.contains(extension)) files.add(model);
        if (model.isFolder) files.add(model);
        if (r) {
          _files.value = files.where(query).toList()
            ..sort((a, b) {
              String aPath = a.isFolder ? '..${a.path}' : a.path;
              String bPath = b.isFolder ? '..${b.path}' : b.path;
              return (aPath).compareTo(bPath);
            });
          //...
        }
      },
    );
    return true;
  }

  @override
  void dispose() {
    _query?.cancel();
    super.dispose();
  }
}
