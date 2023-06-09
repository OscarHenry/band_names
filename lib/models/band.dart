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
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj.containsKey('name') ? obj['name'] : 'no-name',
        votes: obj.containsKey('votes') ? obj['votes'] : 0,
      );

  @override
  String toString() => 'Band(id: $id, name: $name, votes: $votes)';
}
