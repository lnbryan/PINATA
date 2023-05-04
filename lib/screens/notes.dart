import 'package:cloudchain/screens/note_read.dart';
import 'package:flutter/material.dart';
import 'package:mat3d/mat3d.dart';
import 'package:pinata/pinata.dart';
import 'package:text2/text2.dart';

import '../fragments/drawer.dart';
import '../models/doc.dart';
import '../utils/scrolling.dart';

class Dashboard extends StatefulWidget {
  //...Fields
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with //
        SingleTickerProviderStateMixin {
  //...Fields
  final reader = NoteReadSys();
  late AnimationController _dial;

  //...Methods
  @override
  void initState() {
    //...
    _dial = AnimationController(vsync: this);
    _dial.duration = const Duration(milliseconds: 300);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //...
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          Builder(builder: appBar),
          Builder(builder: body),
        ],
        scrollBehavior: const Scrolling(),
      ),
      drawer: const MainDrawer(),
      floatingActionButton: Builder(builder: speedDial),
    );
  }

  Widget appBar(BuildContext context) {
    //...
    return SliverAppBar(
      pinned: true,
      collapsedHeight: 56,
      expandedHeight: 250,
      scrolledUnderElevation: 24,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 5,
        title: const Text2('[bold](Pin[size:.75%](ata))'),
        background: Transform3D(
          mat3D: Mat3D().scale(1.5, 1.8),
          alignment: Alignment.center,
          child: Center(
            child: Opacity(
              opacity: .1,
              child: Text(Pinata.test.toString()),
            ),
          ),
        ),
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsets.only(
          left: 56,
          bottom: 16,
        ),
        stretchModes: const [
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    //...
    return SliverToBoxAdapter(
      child: FutureBuilder(
        future: Pinata.test.pins,
        builder: documents,
      ),
    );
  }

  Widget documents(BuildContext context, snapshot) {
    //...
    final pins = snapshot.data ?? [];
    snapshot as AsyncSnapshot<Iterable<Pin>>;
    //...
    if (!snapshot.hasData) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.none,
      primary: true,
      physics: Scrolling(context).physics,
      itemBuilder: (context, index) {
        return Document(
          loader: loadDocument,
          pin: pins.elementAt(index),
        );
      },
      itemCount: pins.length,
    );
  }

  Widget speedDial(BuildContext context) {
    //...
    final turn = Tween(begin: 0.0, end: 0.325);
    //...
    return FloatingActionButton(
      elevation: 24,
      child: RotationTransition(
        turns: CurvedAnimation(
          parent: turn.animate(_dial),
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutExpo.flipped,
        ),
        child: const Icon(Icons.add),
      ),
      onPressed: () => loadDocument(context),
    );
  }

  void loadDocument(BuildContext context, [document]) {
    //...
    sheet(context) => NoteRead(reader: reader);
    //...
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      _dial.reverse();
      return;
    }
    _dial.forward();
    showBottomSheet(
      context: context,
      elevation: 24.0,
      builder: sheet,
    );
  }

  @override
  void dispose() {
    //...
    _dial.dispose();
    super.dispose();
  }
}

typedef DocLoader = Function(
  BuildContext context, [
  Document? document,
]);
