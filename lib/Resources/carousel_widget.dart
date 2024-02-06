import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class MyImageCarouselWidget extends StatefulWidget {
  @override
  _MyImageCarouselWidgetState createState() => _MyImageCarouselWidgetState();
}

class _MyImageCarouselWidgetState extends State<MyImageCarouselWidget> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline_rounded, color: Colors.grey[700]),
      onPressed: () => _showImageCarouselDialog(context),
    );
  }

  void _showImageCarouselDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageCarouselDialog();
      },
    );
  }
}

class ImageCarouselDialog extends StatefulWidget {
  @override
  _ImageCarouselDialogState createState() => _ImageCarouselDialogState();
}

class _ImageCarouselDialogState extends State<ImageCarouselDialog> {
  int currentImageIndex = 0;

  List<String> imageSubtitles = [
    'Snap the electrodes to the adhesive sticker.',
    'Place the electrodes in the right position.',
    'Connect the electrodes to the device.',
    'Link the device to your mobile app.',
    'Start recording.',
    'Share your report.',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Tutorial',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            //SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(15,15,15,0),
              child: Text(
                'Step ${currentImageIndex + 1}: ${imageSubtitles[currentImageIndex]}',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 500,
                enableInfiniteScroll: false,
                viewportFraction: 1.05,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
              ),
              items: List.generate(6, (index) {
                return Image.asset(
                  'assets/tutorial/${index + 1}.png',
                  fit: BoxFit.contain,
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                    (index) => _buildCarouselIndicator(
                  isActive: index == currentImageIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselIndicator({bool isActive = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.purple[100] : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
