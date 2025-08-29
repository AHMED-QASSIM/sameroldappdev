import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class LoadingImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final double radius;
  final double loadPadding;
  final double? loading_width;
  final double? loading_height;

  const LoadingImage(
      {Key? key,
      required this.image,
      this.width,
      this.height,
      this.radius = 0,
      this.loading_height = 30,
      this.loading_width = 30,
      this.loadPadding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      image,
      fit: BoxFit.fill,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(
                width: width,
                height: height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: loading_width,
                      height: loading_height,
                      padding: EdgeInsets.all(loadPadding),
                      child: Image.asset(
                        "assets/loading.gif",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ));
            break;

          ///if you don't want override completed widget
          ///please return null or state.completedWidget
          //return null;
          //return state.completedWidget;
          case LoadState.completed:
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: state.imageProvider)),
            );
            break;
          case LoadState.failed:
            return GestureDetector(
              child:Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage("assets/image.png"))),
            ),
              onTap: () {
                state.reLoadImage();
              },
            );
            break;
        }
      },
    );
  }
}
