import 'package:flutter/material.dart';
import 'package:mat3d/mat3d.dart';
import 'package:pinata/pinata.dart';
import 'package:preset/preset.dart';

import '../models/doc.dart';
import 'note_edit.dart';

class Scan extends StatefulWidget {
  //...Fields
  final Computation computation;

  const Scan({
    super.key,
    required this.computation,
  });

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  //...Fields
  final _loading = ValueNotifier(false);
  final _address = TextEditingController();
  final _load = MaterialStatesController();

  //...Methods
  @override
  void initState() {
    //...
    _loading.addListener(refresh);
    Future.microtask(() {
      _load.value = {MaterialState.disabled};
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //...
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan document from address',
              style: context.glyphs.onPrimary.titleLarge,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _address,
              readOnly: _loading.value,
              minLines: 1,
              maxLines: 1,
              maxLength: 100,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(6),
                label: const Text('Enter a valid address'),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: context.colors.ascent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: context.colors.ascent,
                  ),
                ),
                suffixIcon: Visibility(
                  visible: _loading.value,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        color: context.colors.foreground,
                        backgroundColor: context.colors.ascent,
                      ),
                    ),
                  ),
                ),
              ),
              onChanged: (value) {
                final address = RegExp(r'^0x\w{15,80}$');
                _load.value = !value.contains(address) //
                    ? {MaterialState.disabled}
                    : {};
              },
            ),
            Transition3D(
              mat3D: Mat3D().upward(8),
              child: ElevatedButton(
                statesController: _load,
                onPressed: loadAddress,
                child: const Text('Load'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() => setState(() {});

  bool loadAddress() {
    //...
    _loading.value = true;
    final addressR = RegExp(r'^0x\w{15,80}$');
    if (!_address.text.contains(addressR)) {
      return _loading.value = false;
    }
    final address = _address.text.replaceFirst('0x', '');
    //...
    Pinata.test.getPin(address).then(
      (pin) {
        pin.contentJson.then((value) {
          widget.computation(
            title: pin.name,
            content: '${value['content'] ?? ''}',
            doc: Document(pin: pin),
          );
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address loaded')),
          );
        });
      },
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid address')),
        );
      },
    ).catchError(
      (e, s) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid address')),
        );
      },
    );
    return true;
  }
}
