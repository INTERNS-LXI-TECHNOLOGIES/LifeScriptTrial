class DropBox {
  final String id;
  final String accepts;

  DropBox({required this.id, required this.accepts});

  factory DropBox.fromJson(Map<String, dynamic> json) {
    return DropBox(
      id: json['id'],
      accepts: json['accepts'],
    );
  }
}
