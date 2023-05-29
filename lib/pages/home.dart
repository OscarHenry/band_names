import 'dart:io';

import 'package:band_names/commons/adaptative_dialog.dart';
import 'package:band_names/commons/band_tile.dart';
import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Variables
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Post Malone', votes: 5),
    Band(id: '3', name: 'Slink Sonic', votes: 5),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames'),
        backgroundColor: Colors.white,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .apply(color: Colors.black87),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: itemBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final band = bands.elementAt(index);
    return Dismissible(
      key: Key(band.id),
      onDismissed: (direction) {
        debugPrint('direction: $direction');
        debugPrint('$band');
        setState(() {
          bands.removeAt(index);
        });
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 18.0),
        color: Colors.red,
        child: const Text(
          'Delete Band',
          style: TextStyle(color: Colors.white),
        ),
      ),
      child: BandTile(
        band: band,
        onTap: () {
          debugPrint(band.name);
        },
      ),
    );
  }

  void addNewBand() {
    showAdaptativeAlertDialog(
      context: context,
      titleText: 'New Band Name:',
      onSubmit: addBandToList,
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      setState(() {
        bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      });
    }
    Navigator.pop(context);
  }
}
