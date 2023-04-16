import 'package:streamit_flutter/models/sources.dart';
import 'package:streamit_flutter/utils/Constants.dart';

class MovieResponse {
  List<MovieData>? data;
  List<Season>? seasons;

  MovieResponse({
    this.data,
    this.seasons,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      seasons: json['seasons'] != null ? (json['seasons'] as List).map((i) => Season.fromJson(i)).toList() : null,
      data: json['data'] != null ? (json['data'] as List).map((i) => MovieData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.seasons != null) {
      data['seasons'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MovieData {
  String? description;
  String? excerpt;
  List<Genre>? genre;
  int? id;
  String? image;
  List<Tag>? tag;
  String? title;
  bool? isHD;
  String? logo;
  String? avgRating;
  String? awardDescription;
  String? censorRating;
  String? embedContent;
  String? choice;
  String? publishDate;
  String? publishDateGmt;
  String? releaseDate;
  String? runTime;
  String? trailerLink;
  String? urlLink;
  String? file;
  List<Visibility>? visibility;
  bool? isInWatchList;
  bool? isLiked;
  int? likes;
  String? attachment;
  String? awardImage;
  List<RestrictSubscriptionPlan>? restSubPlan;
  String? restrictUserStatus;
  RestrictionSetting? restrictionSetting;
  int? noOfComments;
  dynamic imdbRating;
  bool? userHasMembership;

  //video
  List<Genre>? cat;
  String? nameUpcoming;
  bool? isFeatured;
  String? cast;
  int? views;

  //Local
  PostType? postType;

  List<Casts>? castsList;

  //cat detail
  String? characterName;
  String? releaseYear;
  String? shareUrl;
  int? totalSeasons;

  bool? isPostRestricted;
  bool? userHasPmsMember;

  List<Sources>? sourcesList;
  bool? isCommentOpen;

  MovieData({
    this.avgRating,
    this.awardDescription,
    this.censorRating,
    this.description,
    this.embedContent,
    this.excerpt,
    this.genre,
    this.id,
    this.image,
    this.logo,
    this.tag,
    this.title,
    this.choice,
    this.publishDate,
    this.publishDateGmt,
    this.releaseDate,
    this.runTime,
    this.trailerLink,
    this.urlLink,
    this.visibility,
    this.isInWatchList,
    this.isLiked,
    this.likes,
    this.postType,
    this.file,
    this.attachment,
    this.awardImage,
    this.restSubPlan,
    this.restrictUserStatus,
    this.restrictionSetting,
    this.cast,
    this.cat,
    this.isFeatured,
    this.nameUpcoming,
    this.views,
    this.imdbRating,
    this.noOfComments,
    this.castsList,
    this.characterName,
    this.releaseYear,
    this.shareUrl,
    this.totalSeasons,
    this.userHasMembership,
    this.isPostRestricted,
    this.userHasPmsMember,
    this.sourcesList,
    this.isCommentOpen,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      avgRating: json['avg_rating'],
      awardDescription: json['award_description'],
      censorRating: json['censor_rating'],
      description: json['description'],
      excerpt: json['excerpt'],
      embedContent: json['embed_content'],
      genre: json['genre'] != null ? (json['genre'] as List).map((i) => Genre.fromJson(i)).toList() : null,
      id: json['id'],
      image: json['image'],
      tag: json['tag'] != null ? (json['tag'] as List).map((i) => Tag.fromJson(i)).toList() : null,
      title: json['title'],
      logo: json['logo'],
      likes: json['likes'],
      choice: json['post_type'] != null
          ? json['post_type'] == 'movie'
              ? json['movie_choice']
              : json['video_choice']
          : null,
      publishDate: json['publish_date'],
      publishDateGmt: json['publish_date_gmt'],
      releaseDate: json['release_date'],
      runTime: json['run_time'],
      trailerLink: json['trailer_link'],
      urlLink: json['url_link'],
      isInWatchList: json['is_watchlist'],
      file: json['post_type'] != null
          ? json['post_type'] == 'movie'
              ? json['movie_file']
              : json['video_file']
          : null,
      awardImage: json['award_image'],
      isLiked: json['is_liked'] != null
          ? json['is_liked'] == postLike
              ? true
              : false
          : false,
      visibility: json['visibility'] != null ? (json['visibility'] as List).map((i) => Visibility.fromJson(i)).toList() : null,
      postType: json['post_type'] != null
          ? json['post_type'] == 'movie'
              ? PostType.MOVIE
              : json['post_type'] == 'episode'
                  ? PostType.EPISODE
                  : json['post_type'] == 'tv_show'
                      ? PostType.TV_SHOW
                      : json['post_type'] == 'video'
                          ? PostType.VIDEO
                          : PostType.NONE
          : PostType.NONE,
      attachment: json['attachment'],
      restSubPlan: json['restrict_subscription_plan'] != null ? (json['restrict_subscription_plan'] as List).map((e) => RestrictSubscriptionPlan.fromJson(e)).toList() : null,
      restrictUserStatus: json['restrict_user_status'],
      restrictionSetting: json['restriction_setting'] != null ? RestrictionSetting.fromJson(json['restriction_setting']) : null,
      cast: json['cast'],
      cat: json['cat'] != null ? (json['cat'] as List).map((e) => Genre.fromJson(e)).toList() : null,
      isFeatured: json['is_featured'],
      nameUpcoming: json['name_upcoming'],
      views: json['views'],
      imdbRating: json['imdb_rating'] != null ? json['imdb_rating'] : null,
      noOfComments: json['no_of_comments'],
      castsList: json['casts'] != null ? (json['casts'] as List).map((e) => Casts.fromJson(e)).toList() : null,
      characterName: json['character_name'],
      releaseYear: json['release_year'],
      shareUrl: json['share_url'],
      totalSeasons: json['total_seasons'],
      userHasMembership: json['user_has_membership'],
      isPostRestricted: json['is_post_restricted'],
      userHasPmsMember: json['user_has_pms_member'],
      sourcesList: json['sources'] == null ? [] : (json['sources'] as List).map((e) => Sources.fromJson(e)).toList(),
      isCommentOpen: json['is_comment_open'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['movie_file'] = this.file;
    data['description'] = this.description;
    data['excerpt'] = this.excerpt;
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['avg_rating'] = this.avgRating;
    data['award_description'] = this.awardDescription;
    data['censor_rating'] = this.censorRating;
    data['embed_content'] = this.embedContent;
    data['movie_choice'] = this.choice;
    data['publish_date'] = this.publishDate;
    data['publish_date_gmt'] = this.publishDateGmt;
    data['release_date'] = this.releaseDate;
    data['run_time'] = this.runTime;
    data['trailer_link'] = this.trailerLink;
    data['url_link'] = this.urlLink;
    data['logo'] = this.logo;
    data['is_watchlist'] = this.isInWatchList;
    data['is_liked'] = this.isLiked;
    data['likes'] = this.likes;
    data['postType'] = this.postType;
    if (this.genre != null) {
      data['genre'] = this.genre!.map((v) => v.toJson()).toList();
    }
    if (this.tag != null) {
      data['tag'] = this.tag!.map((v) => v.toJson()).toList();
    }
    if (this.visibility != null) {
      data['visibility'] = this.visibility!.map((v) => v.toJson()).toList();
    }
    data['attachment'] = this.attachment;
    data['award_image'] = this.awardImage;
    if (this.restSubPlan != null) {
      data['restrict_subscription_plan'] = this.restSubPlan!.map((e) => e.toJson()).toList();
    }
    data['restrict_user_status'] = this.restrictUserStatus;
    if (this.restrictionSetting != null) {
      data['restriction_setting'] = this.restrictionSetting;
    }
    data['cast'] = this.cast;
    if (data['cat'] != null) {
      data['cat'] = this.cat!.map((e) => e.toJson()).toList();
    }
    data['is_featured'] = this.isFeatured;
    data['name_upcoming'] = this.nameUpcoming;
    data['views'] = this.views;
    data['imdb_rating'] = this.imdbRating;
    data['no_of_comments'] = this.noOfComments;
    if (data['casts'] != null) {
      data['casts'] = this.castsList;
    }
    data['character_name'] = this.characterName;
    data['release_year'] = this.releaseYear;
    data['share_url'] = this.shareUrl;
    data['total_seasons'] = this.totalSeasons;
    data['user_has_membership'] = this.userHasMembership;
    data['user_has_pms_member'] = this.userHasPmsMember;
    data['is_post_restricted'] = this.isPostRestricted;
    if (data['sources'] != null) {
      data['sources'] = this.sourcesList!.map((e) => e.toJson()).toList();
    }
    data['is_comment_open'] = this.isCommentOpen;

    return data;
  }
}

class Casts {
  var id;
  String? character;
  int? position;
  String? image;
  String? name;

  Casts({this.id, this.character, this.position, this.image, this.name});

  factory Casts.fromJson(Map<String, dynamic> json) {
    return Casts(
      id: json['id'].toString(),
      character: json['character'],
      position: json['position'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['character'] = this.character;
    data['position'] = this.position;
    data['name'] = this.name;
    data['image'] = this.image;

    return data;
  }
}

class RestrictSubscriptionPlan {
  String? planId;
  String? label;

  RestrictSubscriptionPlan({this.planId, this.label});

  factory RestrictSubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return RestrictSubscriptionPlan(planId: json['id'], label: json['label']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.planId;
    data['label'] = this.label;
    return data;
  }
}

class RestrictionSetting {
  String? restrictMessage;
  String? restrictUrl;
  String? restrictType;

  RestrictionSetting({this.restrictMessage, this.restrictType, this.restrictUrl});

  factory RestrictionSetting.fromJson(Map<String, dynamic> json) {
    return RestrictionSetting(
      restrictMessage: json['restrict_message'] != null ? json['restrict_message'] : null,
      restrictType: json['restrict_type'] != null ? json['restrict_type'] : null,
      restrictUrl: json['redirect_url'] != null ? json['redirect_url'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restrict_message'] = this.restrictMessage;
    data['restrict_type'] = this.restrictType;
    data['restrict_url'] = this.restrictUrl;
    return data;
  }
}

class Genre {
  int? id;
  String? name;
  String? slug;

  Genre({this.id, this.name, this.slug});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Tag {
  int? id;
  String? name;
  String? slug;

  Tag({this.id, this.name, this.slug});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Visibility {
  int? id;
  String? name;
  String? slug;

  Visibility({this.id, this.name, this.slug});

  factory Visibility.fromJson(Map<String, dynamic> json) {
    return Visibility(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Season {
  String? description;
  List<Episode>? episode;
  String? image;
  String? name;
  int? position;
  String? year;
  String? restrictUserStatus;
  RestrictionSetting? restrictionSetting;
  List<RestrictSubscriptionPlan>? restrictSubscriptionPlan;

  Season({this.description, this.episode, this.image, this.name, this.position, this.year, this.restrictUserStatus, this.restrictionSetting, this.restrictSubscriptionPlan});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      description: json['description'],
      episode: json['episode'] != null ? (json['episode'] as List).map((i) => Episode.fromJson(i)).toList() : null,
      image: json['image'],
      name: json['name'],
      position: json['position'],
      year: json['year'],
      restrictUserStatus: json['restrict_user_status'],
      restrictionSetting: json['restriction_setting'] != null ? RestrictionSetting.fromJson(json['restriction_setting']) : null,
      restrictSubscriptionPlan: json['restrict_subscription_plan'] != null ? (json['restrict_subscription_plan'] as List).map((e) => RestrictSubscriptionPlan.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['image'] = this.image;
    data['name'] = this.name;
    data['position'] = this.position;
    data['year'] = this.year;
    if (this.episode != null) {
      data['episode'] = this.episode!.map((v) => v.toJson()).toList();
    }
    data['restrict_user_status'] = this.restrictUserStatus;
    data['restriction_setting'] = this.restrictionSetting;
    if (data['restrict_subscription_plan'] != null) {
      data['restrict_subscription_plan'] = this.restrictSubscriptionPlan!.map((e) => e.toJson());
    }

    return data;
  }
}

class Episode {
  String? description;
  String? embedContent;
  String? choice;
  String? episodeNumber;
  String? excerpt;
  int? id;
  String? image;
  bool? isFeatured;
  String? isLiked;
  bool? isWatchlist;
  int? likes;
  String? postType;
  String? releaseDate;
  String? runTime;
  String? title;
  String? tvShowId;
  String? file;
  String? urlLink;
  String? restrictUserStatus;
  String? trailerLink;
  int? noOfComments;

  RestrictionSetting? restrictionSetting;
  List<RestrictSubscriptionPlan>? restrictSubscriptionPlan;

  bool? isPostRestricted;
  bool? userHasPmsMember;
  List<Sources>? sourcesList;
  bool? isCommentOpen;

  Episode({
    this.description,
    this.embedContent,
    this.choice,
    this.episodeNumber,
    this.excerpt,
    this.id,
    this.image,
    this.isFeatured,
    this.isLiked,
    this.isWatchlist,
    this.likes,
    this.postType,
    this.releaseDate,
    this.runTime,
    this.title,
    this.tvShowId,
    this.file,
    this.urlLink,
    this.restrictUserStatus,
    this.restrictionSetting,
    this.restrictSubscriptionPlan,
    this.trailerLink,
    this.noOfComments,
    this.isPostRestricted,
    this.userHasPmsMember,
    this.sourcesList,
    this.isCommentOpen,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      description: json['description'],
      file: json['episode_file'],
      urlLink: json['url_link'],
      embedContent: json['embed_content'],
      choice: json['episode_choice'],
      episodeNumber: json['episode_number'],
      excerpt: json['excerpt'],
      id: json['id'],
      image: json['image'],
      isFeatured: json['is_featured'],
      isLiked: json['is_liked'],
      isWatchlist: json['is_watchlist'],
      likes: json['likes'],
      postType: json['post_type'],
      releaseDate: json['release_date'],
      runTime: json['run_time'],
      title: json['title'],
      tvShowId: json['tv_show_id'],
      restrictUserStatus: json['restrict_user_status'],
      restrictionSetting: json['restriction_setting'] != null ? RestrictionSetting.fromJson(json['restriction_setting']) : null,
      restrictSubscriptionPlan: json['restrict_subscription_plan'] != null ? (json['restrict_subscription_plan'] as List).map((e) => RestrictSubscriptionPlan.fromJson(e)).toList() : null,
      trailerLink: json['trailer_link'],
      noOfComments: json['no_of_comments'],
      isPostRestricted: json['is_post_restricted'],
      userHasPmsMember: json['user_has_pms_member'],
      sourcesList: json['sources'] == null ? [] : ((json['sources'] as List).map((e) => Sources.fromJson(e)).toList()),
      isCommentOpen: json['is_comment_open'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['episode_file'] = this.file;
    data['url_link'] = this.urlLink;
    data['description'] = this.description;
    data['embed_content'] = this.embedContent;
    data['episode_choice'] = this.choice;
    data['episode_number'] = this.episodeNumber;
    data['excerpt'] = this.excerpt;
    data['id'] = this.id;
    data['image'] = this.image;
    data['is_featured'] = this.isFeatured;
    data['is_liked'] = this.isLiked;
    data['is_watchlist'] = this.isWatchlist;
    data['likes'] = this.likes;
    data['post_type'] = this.postType;
    data['release_date'] = this.releaseDate;
    data['run_time'] = this.runTime;
    data['title'] = this.title;
    data['tv_show_id'] = this.tvShowId;
    data['restrict_user_status'] = this.restrictUserStatus;
    if (data['restriction_setting'] != null) {
      data['restriction_setting'] = this.restrictionSetting;
    }
    if (data['restrict_subscription_plan'] != null) {
      data['restrict_subscription_plan'] = this.restrictSubscriptionPlan!.map((e) => e.toJson());
    }
    data['trailer_link'] = this.trailerLink;
    data['no_of_comments'] = this.noOfComments;
    data['is_post_restricted'] = this.isPostRestricted;
    data['user_has_pms_member'] = this.userHasPmsMember;
    if (data['sources'] != null) {
      data['sources'] = this.sourcesList!.map((e) => e).toList();
    }
    data['is_comment_open'] = this.isCommentOpen;

    return data;
  }
}
