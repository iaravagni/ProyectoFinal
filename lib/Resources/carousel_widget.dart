import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class MyImageCarouselWidget extends StatefulWidget {
  @override
  _MyImageCarouselWidgetState createState() => _MyImageCarouselWidgetState();
}

class _MyImageCarouselWidgetState extends State<MyImageCarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline_rounded), // Replace with your desired icon
      onPressed: () => _showImageCarouselDialog(context),
    );
  }

  void _showImageCarouselDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 300,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    enableInfiniteScroll: false,
                  ),
                  items: List.generate(
                    6, // Change this to the total number of images
                        (index) {
                      return Image.asset(
                        'assets/Tutorial/${index + 1}.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                        (index) => _buildCarouselIndicator(
                      isActive: index == 0, // Mark the first image as active
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // Function to build the carousel indicator
  Widget _buildCarouselIndicator({bool isActive = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}
