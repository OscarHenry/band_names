import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ServerStatus: ${socketService.serverStatus.name}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .apply(color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onPressed(context),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  void onPressed(BuildContext context) {
    context.read<SocketService>().emit(
      'emitir-mensaje',
      [
        {
          'nombre': 'Flutter',
          'mensaje': 'Hola desde Flutter',
        }
      ],
    );
  }
}
