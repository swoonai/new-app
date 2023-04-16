import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/models/MovieDetailResponse.dart';
import 'package:streamit_flutter/screens/ViewAllMoviesGridScreen.dart';
import 'package:streamit_flutter/screens/movieDetailComponents/ItemHorizontalList.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';

class UpcomingRelatedMovieListWidget extends StatelessWidget {
  final AsyncSnapshot<MovieDetailResponse>? snap;

  UpcomingRelatedMovieListWidget({this.snap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (snap!.data!.recommendedMovie.validate().isNotEmpty) ...[
          headingWidViewAll(
            context,
            language!.recommendedMovies,
            callback: () async {
              youtubePlayerController!.pause();
              await ViewAllMovieGridScreen(
                title: language!.recommendedMovies,
                upcomingVideo: snap!.data!.recommendedMovie!,
              ).launch(context);
              youtubePlayerController!.play();
            },
            showViewMore: false,
          ).paddingSymmetric(horizontal: 16,vertical: 16),
          ItemHorizontalList(snap!.data!.recommendedMovie!, isMovie: false)
        ],
        if (snap!.data!.upcomingMovie.validate().isNotEmpty) ...[
          headingWidViewAll(
            context,
            language!.upcomingMovies,
            callback: () async {
              youtubePlayerController!.pause();
              await ViewAllMovieGridScreen(
                title: language!.upcomingMovies,
                upcomingVideo: snap!.data!.upcomingMovie!,
              ).launch(context);
              youtubePlayerController!.play();
            },
            showViewMore: false,
          ).paddingAll(16),
          ItemHorizontalList(snap!.data!.upcomingMovie!, isMovie: false)
        ],
        if (snap!.data!.upcomingVideo.validate().isNotEmpty)
          Column(
            children: [
              headingWidViewAll(
                context,
                language!.upcomingVideo,
                callback: () async {
                  youtubePlayerController!.pause();
                  await ViewAllMovieGridScreen(
                    title: language!.upcomingVideo,
                    upcomingVideo: snap!.data!.upcomingVideo!,
                  ).launch(context);
                  youtubePlayerController!.play();
                },
                showViewMore: false,
              ).paddingAll(16),
              ItemHorizontalList(snap!.data!.upcomingVideo!, isMovie: false),
            ],
          ),
      ],
    );
  }
}
