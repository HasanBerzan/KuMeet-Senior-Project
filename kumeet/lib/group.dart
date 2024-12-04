class Group {
  final String? id;
  final String? imagePath;
  final String name;
  //final String description;
  final int capacity;
  final int? memberCount;

  Group({
    this.id,
    this.imagePath,
    required this.name,
    //required this.description,
    required this.capacity,
    this.memberCount

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      //'description': description,
      'capacity': capacity,

    };
  }
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      imagePath: 'images/group_image1.png',
      name: json['groupName'],
      //description: json['eventDescription'],
      capacity: json['capacity'] ?? 0,
      memberCount: json['memberCount'] ?? 0
    );
  }
  
}