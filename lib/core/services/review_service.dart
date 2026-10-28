import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Review {
  final String id;
  final String recipeId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'recipeId': recipeId,
        'userId': userId,
        'userName': userName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        recipeId: json['recipeId'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        rating: (json['rating'] as num).toDouble(),
        comment: json['comment'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ReviewService {
  static const String _key = 'recipe_reviews';

  static Future<List<Review>> _getAllReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList(_key) ?? [];
    return json
        .map((r) => Review.fromJson(jsonDecode(r) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _saveAllReviews(List<Review> reviews) async {
    final prefs = await SharedPreferences.getInstance();
    final json = reviews.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_key, json);
  }

  static Future<List<Review>> getReviewsForRecipe(String recipeId) async {
    final all = await _getAllReviews();
    final filtered = all.where((r) => r.recipeId == recipeId).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  static Future<Review?> getUserReview({
    required String recipeId,
    required String userId,
  }) async {
    final all = await _getAllReviews();
    try {
      return all
          .firstWhere((r) => r.recipeId == recipeId && r.userId == userId);
    } catch (_) {
      return null;
    }
  }

  static Future<int> countUserReviews(String userId) async {
    final all = await _getAllReviews();
    return all.where((r) => r.userId == userId).length;
  }

  static Future<void> addOrUpdateReview({
    required String recipeId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    final all = await _getAllReviews();
    final index =
        all.indexWhere((r) => r.recipeId == recipeId && r.userId == userId);

    if (index >= 0) {
      all[index] = Review(
        id: all[index].id,
        recipeId: recipeId,
        userId: userId,
        userName: userName,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );
    } else {
      all.add(Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        recipeId: recipeId,
        userId: userId,
        userName: userName,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      ));
    }
    await _saveAllReviews(all);
  }

  static Future<void> deleteReview(String reviewId) async {
    final all = await _getAllReviews();
    all.removeWhere((r) => r.id == reviewId);
    await _saveAllReviews(all);
  }

  static Future<Map<String, dynamic>> getRatingSummary(String recipeId) async {
    final reviews = await getReviewsForRecipe(recipeId);
    if (reviews.isEmpty) {
      return {
        'average': 0.0,
        'count': 0,
        'distribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
      };
    }

    final total = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    final average = total / reviews.length;

    final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      final star = r.rating.round();
      distribution[star] = (distribution[star] ?? 0) + 1;
    }

    return {
      'average': average,
      'count': reviews.length,
      'distribution': distribution
    };
  }
}
