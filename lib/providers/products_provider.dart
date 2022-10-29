import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _productsList = [];
      // _productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price: double.parse(
                element.get('price'),
              ),
              salePrice: element.get('salePrice'),
              isOnSale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
            ));
      });
    });
    notifyListeners();
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findProdByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }

  // static final List<ProductModel> _productsList = [
  //   ProductModel(
  //     id: 'Aberfeldy',
  //     title: 'Aberfeldy 12 Years',
  //     price: 35000,
  //     salePrice: 30000,
  //     imageUrl: 'https://i.ibb.co/tmjmf4L/spirits.png',
  //     productCategoryName: 'Spirits',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Gekkeikan',
  //     title: 'Gekkeikan Horin Sake',
  //     price: 6400,
  //     salePrice: 6400,
  //     imageUrl: 'https://i.ibb.co/rMF8vqm/sake.png',
  //     productCategoryName: 'Sake',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Ocho',
  //     title: 'Bacardi Reserva Ocho',
  //     price: 22850,
  //     salePrice: 22000,
  //     imageUrl: 'https://i.ibb.co/fCB4nbT/Bacardi-Reserva-Ocho.png',
  //     productCategoryName: 'Spirits',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Mateus',
  //     title: 'Mateus Rosé Original',
  //     price: 4850,
  //     salePrice: 4200,
  //     imageUrl: 'https://i.ibb.co/tmr5HHW/Mateus-Ros-Original.png',
  //     productCategoryName: 'Wine',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Merlot',
  //     title: 'Barefoot Merlot',
  //     price: 5000,
  //     salePrice: 5000,
  //     imageUrl: 'https://i.ibb.co/7J45ykh/Barefoot-Merlot.png',
  //     productCategoryName: 'Spirits',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Ale',
  //     title: 'Bickford & Sons Ale',
  //     price: 950,
  //     salePrice: 850,
  //     imageUrl: 'https://i.ibb.co/p035wW2/Ginger-Ale.png',
  //     productCategoryName: 'Mixers',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Raspberri',
  //     title: 'Absolut Raspberri',
  //     price: 12700,
  //     salePrice: 12500,
  //     imageUrl: 'https://i.ibb.co/ggwsxk3/Absolut-Raspberri.png',
  //     productCategoryName: 'Spirits',
  //     isOnSale: true,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Magnum',
  //     title: 'Imperial Brut Magnum',
  //     price: 65600,
  //     salePrice: 65600,
  //     imageUrl: 'https://i.ibb.co/mS32x4p/Magnum.png',
  //     productCategoryName: 'Champagne',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  //   ProductModel(
  //     id: 'Whiskey',
  //     title: 'Teeling Batch Whiskey',
  //     price: 21900,
  //     salePrice: 21900,
  //     imageUrl: 'https://i.ibb.co/s1cv1zv/Whiskey.png',
  //     productCategoryName: 'Spirits',
  //     isOnSale: false,
  //     isPiece: false,
  //   ),
  // ];
}
