import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget buildCachedNetworkImage({required String imageUrl}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => Image.network(
      imageUrl,
      fit: BoxFit.fill,
    ),
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}