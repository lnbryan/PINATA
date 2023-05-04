part of pinata.note_edit;

const disabled = {MaterialState.disabled};

class NoteEditSys extends ChangeNotifier {
  //...Static Fields
  final _head = TextEditingController();
  final _body = TextEditingController();
  final _save = MaterialStatesController();

  //...Static Methods
  NoteEditSys({
    Function(Function() fn)? all,
    Function(Function() fn)? head,
    Function(Function() fn)? body,
    Function(Function() fn)? save,
  }) {
    //...all
    if (all != null) _head.addListener(() => all(() {}));
    if (all != null) _body.addListener(() => all(() {}));
    if (all != null) _save.addListener(() => all(() {}));
    //...each
    if (head != null) _head.addListener(() => head(() {}));
    if (body != null) _body.addListener(() => body(() {}));
    if (save != null) _save.addListener(() => save(() {}));
    //...init
    _body.addListener(() => canSave = this.body.length > 8);
  }

  //...Getters
  String get head => _head.text;

  String get body => _body.text;

  //...Setters
  set head(String head) {
    //...
    _head.text = head;
    notifyListeners();
  }

  set body(String body) {
    //...
    _body.text = body;
    notifyListeners();
  }

  set canSave(bool canSave) {
    //...
    _save.value = canSave ? {} : disabled;
  }

  void compute({String? head, String? body}) {
    //...
    final reg = RegExp(r'^[\w\s]+$');
    //...
    if (body != null && body.length > 25000) {
      throw NoteEditError(
        'Content size cannot be more than 25000',
      );
    } else if (body != null && body.isEmpty) {
      throw NoteEditError(
        'Content size cannot be empty',
      );
    } else {
      this.body = body ??= this.body;
      if (head != null && head.length <= 40) {
        if (head.contains(reg)) this.head = head;
      }
    }
  }

  @override
  void dispose() {
    _head.dispose();
    _body.dispose();
    _save.dispose();
    super.dispose();
  }
}

class NoteEditError extends Error {
  //...
  final String reason;

  NoteEditError(this.reason);
}
