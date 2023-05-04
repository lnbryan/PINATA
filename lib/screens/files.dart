import 'dart:async';
import 'dart:io';

import 'package:cloudchain/screens/files_search.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preset/preset.dart';

import '../models/file.dart';
import 'note_edit.dart';

class MyFiles extends StatefulWidget {
  //...Fields
  final NoteEditSys editor;

  const MyFiles({
    super.key,
    required this.editor,
  });

  //...Getters
  ModalRoute get route {
    return MaterialPageRoute(
      builder: (context) => this,
    );
  }

  @override
  State<MyFiles> createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  //...Fields
  late Directory? _directory;
  StreamSubscription? _query;
  final _files = ValueNotifier(<MyFile>[]);
  final _loading = ValueNotifier(true);

  //...Methods
  @override
  void initState() {
    //...
    _directory = null;
    _files.addListener(refresh);
    _loading.addListener(refresh);
    Future.delayed(const Duration(seconds: 1), () {
      getDownloadsDirectory().then((value) {
        loadFilesFrom(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //...
    final path = _directory?.path;
    //...
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: const Text('Select a file'),
        elevation: 0.1,
        scrolledUnderElevation: 16.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FileSearch.sys(
                  directory: _directory,
                  editor: widget.editor,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: InkWell(
            onTap: () {
              loadFilesFrom(_directory?.parent);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.chevron_left),
                  Image.asset(
                    'assets/opened_folder.png',
                    color: context.colors.foreground,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      path ?? 'Files',
                      maxLines: 1,
                      style: context.glyphs.onPrimary.labelMedium,
                    ),
                  ),
                  if (_loading.value)
                    CircularProgressIndicator(
                      color: context.colors.foreground,
                      backgroundColor: context.colors.ascent,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Builder(builder: files),
    );
  }

  @override
  void dispose() {
    _query?.cancel();
    _files.dispose();
    _loading.dispose();
    super.dispose();
  }

  Widget files(BuildContext context) {
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
        if (_files.value.isEmpty && !_loading.value)
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

  void refresh() => setState(() {});

  bool loadFilesFrom(Directory? dir, {bool r = true}) {
    //...
    _loading.value = true;
    final files = <MyFile>[];
    if (dir == null) return false;
    if (dir.path == _directory?.path) return false;
    check(String element) => element.isNotEmpty;
    if (r) _directory = dir;
    const li = 'json, txt, js, html, htm, md, xml,'
        ' css, php, py, cp, rtf, ttf, otf, doc, ';
    //...
    _query?.cancel();
    _query = dir.list().listen(
      (file) {
        final pathAndExt = RegExp(r'(.+)\.(\w+)$');
        final name = file.uri.pathSegments.lastWhere(check);
        final match = pathAndExt.firstMatch(name.toLowerCase());
        final extension = match?.group(2) ?? 'unknown';
        final model = MyFile(
          path: file.path,
          name: match?.group(1) ?? name,
          isFolder: file is Directory,
          loader: loadFilesFrom,
          editor: widget.editor,
          extension: extension,
          file: file,
        );
        if (li.contains(extension)) files.add(model);
        if (model.isFolder) files.add(model);
        if (r) {
          _files.value = files
            ..sort((a, b) {
              String aPath = a.isFolder ? '..${a.path}' : a.path;
              String bPath = b.isFolder ? '..${b.path}' : b.path;
              return (aPath).compareTo(bPath);
            });
          //...
        }
      },
    );
    _query?.asFuture().then((value) {
      return _loading.value = false;
    });
    return true;
  }
}
