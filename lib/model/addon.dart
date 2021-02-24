import 'package:yukyakyuk_app/model/addonCategory.dart';

class AddOn {
  final int id;
  final String name;
  final int price;
  final int addon_category_id;
  final int user_id;
  final String created_at;
  final String updated_at;
  final int is_active;
  final AddonCategory addonCategory;

  AddOn(
      {this.id,
      this.name,
      this.price,
      this.addon_category_id,
      this.user_id,
      this.created_at,
      this.updated_at,
      this.is_active,
      this.addonCategory});

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        addon_category_id: json['addon_category_id'],
        user_id: json['user_id'],
        created_at: json['created_at'],
        updated_at: json['updated_at'],
        is_active: json['is_active'],
        addonCategory: json['addon_category']);
  }
}
