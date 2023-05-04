part of files.search;

class FileSearchSys extends SearchDelegate<MyFile> {
  //...Fields
  final Directory? directory;
  final NoteEditSys editor;

  FileSearchSys({
    this.directory,
    required this.editor,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    //...
    return [];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    //...
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        color: context.colors.primary,
        titleSpacing: 0,
        elevation: 0,
        scrolledUnderElevation: 8.0,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //...
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    //...
    return FileSearch(
      editor: editor,
      directory: directory,
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //...
    return FileSearch(
      editor: editor,
      directory: directory,
      query: query,
    );
  }
}
