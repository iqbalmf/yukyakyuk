class AddonCategory {
  int id;
  String name;
  String type;
  int user_id;
  String created_at;
  String update_at;

  AddonCategory({
    this.id,
    this.name,
    this.type,
    this.user_id,
    this.created_at,
    this.update_at
  });
  factory AddonCategory.fromJson(Map<String, dynamic> json){
    return AddonCategory(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      user_id: json['user_id'],
      created_at: json['created_at'],
      update_at: json['update_at'],
    );
  }
}