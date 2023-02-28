import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildCachedNetworkImage({required String imageUrl}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    // imageUrl: 'https://cdn.wallpapersafari.com/68/18/cM9i4A.jpeg',
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
    ),
    // Image.network(imageProvider, fit: BoxFit.fill),
    // placeholder: (context, url) => const Padding(
    //   padding: EdgeInsets.all(8.0),
    //   child: CircularProgressIndicator()
    // ),
    placeholder: (context, url) =>
        Image.asset('assets/images/time_loading.gif', fit: BoxFit.cover),
    errorWidget: (context, url, error) =>
        Image.asset('assets/images/placeholder.jfif', fit: BoxFit.cover),
  );
}
