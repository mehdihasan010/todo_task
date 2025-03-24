class Todo {
  final String id;
  final String title;
  final String description;
  final int createdAt;
  String status; // 'ready' | 'pending' | 'completed'

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  // Convert Todo to CSV row
  String toCsv() {
    return '$id,$title,$description,$createdAt,$status';
  }

  // Create Todo from CSV row
  factory Todo.fromCsv(String csvRow) {
    final values = csvRow.split(',');
    return Todo(
      id: values[0],
      title: values[1],
      description: values[2],
      createdAt: int.parse(values[3]),
      status: values[4],
    );
  }

  // Convert Todo to Map for JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'status': status,
    };
  }

  // Create Todo from JSON Map
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      createdAt:
          json['createdAt'] is int
              ? json['createdAt']
              : int.parse(json['createdAt'].toString()),
      status: json['status'].toString(),
    );
  }
}
