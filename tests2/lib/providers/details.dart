import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_before/db/download_helper.dart';
import 'package:test_before/db/favorite_helper.dart';
import 'package:test_before/podo/category.dart';
import 'package:test_before/util/api.dart';

class DetailsProvider extends ChangeNotifier{
  String message;
  CategoryFeed related = CategoryFeed();
  bool loading = true;
  Entry entry;
  var favDB = FavoriteDB();
  var dlDB = DownloadsDB();

  bool faved = false;
  bool downloaded = false;

  static var httpClient = HttpClient();


  getFeed(String url) async{
    setLoading(true);
    checkFav();
    checkDownload();
    Api.getCategory(url).then((feed){
      setRelated(feed);
      setLoading(false);
    }).catchError((e){
      throw(e);
    });
  }

  checkFav() async{
    List c = await favDB.check({"id": entry.published.t});
    if(c.isNotEmpty){
      setFaved(true);
    }else{
      setFaved(false);
    }
  }

  addFav() async{
    await favDB.add({"id": entry.published.t, "item": entry.toJson()});
    checkFav();
  }

  removeFav() async{
    favDB.remove({"id": entry.published.t}).then((v){
      print(v);
      checkFav();
    });
  }

  checkDownload() async{
    List c = await dlDB.check({"id": entry.published.t});
    if(c.isNotEmpty){
      setDownloaded(true);
    }else{
      setDownloaded(false);
    }
  }

  Future<List> getDownload() async{
    List c = await dlDB.check({"id": entry.published.t});
    return c;
  }

  addDownload(Map body) async{
    await dlDB.add(body);
    checkDownload();
  }

  removeDownload() async{
    dlDB.remove({"id": entry.published.t}).then((v){
      print(v);
      checkDownload();
    });
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setMessage(value) {
    message = value;
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIos: 1,
    );
    notifyListeners();
  }

  String getMessage() {
    return message;
  }

  void setRelated(value) {
    related = value;
    notifyListeners();
  }

  CategoryFeed getRelated() {
    return related;
  }

  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }

  void setDownloaded(value) {
    downloaded = value;
    notifyListeners();
  }
}