import 'package:flutter/material.dart';
import 'package:liquor_purchase_app/Widgets/categories_widget.dart';
import 'package:liquor_purchase_app/Widgets/text_widget.dart';
import 'package:liquor_purchase_app/services/utils.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  List<Color> gridColors = [
    const Color(0xffc4c4c0),
    const Color(0xffc4c4c0),
    const Color(0xffc4c4c0),
    const Color(0xffc4c4c0),
    const Color(0xffc4c4c0),
    const Color(0xffc4c4c0),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/spirits.png',
      'catText': 'Spirits',
    },
    {
      'imgPath': 'assets/images/cat/wine.png',
      'catText': 'Wine',
    },
    {
      'imgPath': 'assets/images/cat/champagne.png',
      'catText': 'Champagne',
    },
    {
      'imgPath': 'assets/images/cat/sake.png',
      'catText': 'Sake',
    },
    {
      'imgPath': 'assets/images/cat/mixers.png',
      'catText': 'Mixers',
    },
    {
      'imgPath': 'assets/images/cat/beer.png',
      'catText': 'Beer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Categories',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(6, (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedcolor: gridColors[index],
              );
            }),
          ),
        ));
  }
}
