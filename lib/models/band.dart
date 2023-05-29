/// Band model
///
/// This model is used to create a band object
class Band {
  /// Band identifier
  String id;

  /// Band name
  String name;

  /// Band votes
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj['id'],
        name: obj['name'],
        votes: obj['votes'],
      );

  @override
  String toString() => 'Band(id: $id, name: $name, votes: $votes)';
}
