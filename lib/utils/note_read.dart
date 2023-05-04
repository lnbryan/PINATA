part of pinata.note_read;

final now = DateTime.now();

class NoteReadSys extends ChangeNotifier {
  //...Static Fields
  final _head = ValueNotifier('');
  final _body = ValueNotifier('');
  final _date = ValueNotifier(now);
  final _serial = ValueNotifier('');
  final _address = ValueNotifier('');

  //...Static Methods
  NoteReadSys({
    Function(Function() fn)? all,
    Function(Function() fn)? head,
    Function(Function() fn)? body,
    Function(Function() fn)? xtra,
  }) {
    //...all
    if (all != null) _head.addListener(() => all(() {}));
    if (all != null) _body.addListener(() => all(() {}));
    if (all != null) _date.addListener(() => all(() {}));
    if (all != null) _serial.addListener(() => all(() {}));
    if (all != null) _address.addListener(() => all(() {}));
    //...each
    if (head != null) _head.addListener(() => head(() {}));
    if (body != null) _body.addListener(() => body(() {}));
    if (xtra != null) _date.addListener(() => xtra(() {}));
    if (xtra != null) _serial.addListener(() => xtra(() {}));
    if (xtra != null) _address.addListener(() => xtra(() {}));
  }

  //...Getters
  String get head => _head.value;

  String get body => _body.value;

  DateTime get date => _date.value;

  String get serial => _serial.value;

  String get address => _address.value;

  //...Setters
  set head(String head) {
    //...
    _head.value = head;
    notifyListeners();
  }

  set body(String body) {
    //...
    _body.value = body;
    notifyListeners();
  }

  set serial(String serial) {
    //...
    _serial.value = serial;
    notifyListeners();
  }

  set date(DateTime date) {
    //...
    _date.value = date;
    notifyListeners();
  }

  set address(String address) {
    //...
    _address.value = address;
    notifyListeners();
  }

  set document(Document document) {
    //...
    head = document.pin.name;
    serial = document.pin.serial;
    date = document.pin.datePinned;
    address = document.pin.address;
    document.pin.contentJson.then((value) {
      body = '${value['content']}';
    });
  }

  @override
  void dispose() {
    _head.dispose();
    _body.dispose();
    _serial.dispose();
    _date.dispose();
    _address.dispose();
    super.dispose();
  }
}
