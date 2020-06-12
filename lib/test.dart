import 'package:flutter/material.dart';

main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carousel in vertical scrollable'),
      ),
      body: 
        SizedBox(
          height: 200.0,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.8),
            itemCount: 4,
            itemBuilder: (BuildContext context, int itemIndex) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  child: Text(itemIndex.toString()),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              );
            },
          ),
        )
    );
  }
}