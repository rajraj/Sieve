import 'package:flutter/material.dart';

import '../../domain/entities/news.dart';

class NewsModel extends News {
  final String title;
  final String desc;

  NewsModel({@required this.title, @required this.desc})
      : super(title:title,desc:desc);

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(title: json['title'], desc: (json['description']));
  }

  static List<NewsModel> fromJsonList(Map<String, dynamic> json){
    List<NewsModel> _news = new List<NewsModel>();
    int _len = json['news'].length;
    for (var i=0; i<_len; i++){
      _news.add(NewsModel.fromJson(json['title'][i]));
    }
    return _news;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': super.getTitle,
      'desc': super.getDesc,
    };
  }
}
