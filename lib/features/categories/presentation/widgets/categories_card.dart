import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/Constants/theme_data.dart';

class CategoriesCard extends StatelessWidget {
  final int id;
  final String name;
  final String icon;
  const CategoriesCard(
      {Key key, @required this.id, @required this.name, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4.3,
      width: MediaQuery.of(context).size.height / 4.3,
      alignment: Alignment.center,
      child: GestureDetector(
        child: Card(
          elevation: 4,
          borderOnForeground: true,
          margin: EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: categoryGradientData,
            child: Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 12,
                    ),
                  ),
                  Icon(
                    IconData(int.parse('0x' + icon), fontFamily: 'MaterialIcons'),
                    color: Colors.white,
                    size: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () => print (id),
      ),
    );
  }


}
