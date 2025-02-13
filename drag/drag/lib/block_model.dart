class Block {
  final String id;
  final String shape;
  final String size;
  final String color;
  final String message;

  Block({required this.id, required this.shape, required this.size, required this.color, required this.message});

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'],
      shape: json['shape'],
      size: json['size'],
      color: json['color'],
      message: json['message'],
    );
  }
}
