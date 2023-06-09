import 'package:band_names/commons/adaptative_dialog.dart';
import 'package:band_names/commons/band_tile.dart';
import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Variables
  late final socketService = Provider.of<SocketService>(context, listen: false);
  List<Band> bands = [];

  @override
  void initState() {
    subscribeToActiveBandsEvent();
    super.initState();
  }

  @override
  dispose() {
    unsubscribeEvents();
    super.dispose();
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Selector<SocketService, ServerStatus>(
              selector: (_, state) => state.serverStatus,
              builder: (context, serverStatus, ___) => serverStatus.icon,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          if (dataMap.isNotEmpty)
            PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 56,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              // colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Votes",
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: true,
                decimalPlaces: 1,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: itemBuilder,
            ),
          ),
        ],
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
      onDismissed: (_) => deleteBand(band),
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
        onTap: () => voteBand(band),
      ),
    );
  }

  /// Methods
  void subscribeToActiveBandsEvent() {
    socketService.socket.on('active-bands', (payload) {
      debugPrint('active-bands: $payload');
      bands = (payload as List)
          .map<Band>((bandData) => Band.fromMap(bandData))
          .toList();
      setState(() {});
    });
  }

  void unsubscribeEvents() {
    socketService.socket.off('active-bands');
  }

  void voteBand(Band band) {
    debugPrint('vote for Band ${band.id}');
    socketService.emit('vote-band', {'id': band.id});
  }

  void deleteBand(Band band) {
    debugPrint('delete band ${band.id}');
    socketService.emit('delete-band', {'id': band.id});
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
      socketService.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Map<String, double> get dataMap {
    final dataMap = <String, double>{};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }
    return dataMap;
  }
}
