class Task {
  final String id;
  final String title;
  final String room;
  final bool done;

  const Task({
    required this.id,
    required this.title,
    required this.room,
    required this.done,
  });

  Task copyWith({String? title, String? room, bool? done}) {
    return Task(
      id: id,
      title: title ?? this.title,
      room: room ?? this.room,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'room': room,
      'done': done,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      room: json['room'] as String? ?? 'Cuisine',
      done: json['done'] as bool? ?? false,
    );
  }
}
