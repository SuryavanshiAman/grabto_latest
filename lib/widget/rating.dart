import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color color;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    required this.color,
    this.size = 25,
    this.onRatingChanged,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      return const SizedBox(); // don’t render extra stars
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: size,
      );
    }

    return InkResponse(
      onTap: onRatingChanged == null
          ? null
          : () => onRatingChanged!(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rating.ceil(),
            (index) => buildStar(context, index),
      ),
    );
  }
}
