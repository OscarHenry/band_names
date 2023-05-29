import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';

class BandTile extends StatelessWidget {
  const BandTile({
    super.key,
    required this.band,
    this.onTap,
  });

  final Band band;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          band.name.substring(0, 2),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      title: Text(band.name),
      trailing: Text(
        '${band.votes}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
