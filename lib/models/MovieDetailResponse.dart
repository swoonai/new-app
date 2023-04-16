import 'MovieData.dart';

class MovieDetailResponse {
  MovieData? data;
  List<MovieData>? recommendedMovie;
  List<MovieData>? upcomingMovie;
  List<MovieData>? upcomingVideo;
  List<Season>? seasons;

  MovieDetailResponse({
    this.data,
    this.recommendedMovie,
    this.seasons,
    this.upcomingMovie,
    this.upcomingVideo,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailResponse(
      data: json['data'] != null ? MovieData.fromJson(json['data']) : null,
      recommendedMovie: json['recommended_movie'] != null ? (json['recommended_movie'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
      seasons: json['seasons'] != null ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList() : null,
      upcomingMovie: json['upcomming_movie'] != null ? (json['upcomming_movie'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
      upcomingVideo: json['upcomming_video'] != null ? (json['upcomming_video'] as List).map((e) => MovieData.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.recommendedMovie != null) {
      data['recommended_movie'] = this.recommendedMovie!.map((v) => v.toJson()).toList();
    }
    if (this.upcomingMovie != null) {
      data['upcomming_movie'] = this.upcomingMovie!.map((v) => v.toJson()).toList();
    }
    if (this.upcomingVideo != null) {
      data['upcomming_video'] = this.upcomingVideo!.map((e) => e.toJson()).toList();
    }
    if (this.seasons != null) {
      data['seasons'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
