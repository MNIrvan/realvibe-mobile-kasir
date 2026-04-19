import '../models/food_model.dart';

class DummyData {
  static List<FoodMenu> menuList = [
    FoodMenu(
      id: 1,
      name: "Ayam Geprek",
      subName: "Spicy Smashed Chicken",
      price: 15000,
      image: "https://vapa.vn/wp-content/uploads/2022/12/anh-mon-an-dep-001.jpg",
    ),
    FoodMenu(
      id: 2,
      name: "Tahu Crispy",
      subName: "Crispy Tofu",
      price: 10000,
      image: "https://picsum.photos/200/200",
    ),
    // Tambahkan data lainnya di sini
  ];
}