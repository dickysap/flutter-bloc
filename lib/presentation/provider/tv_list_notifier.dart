import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_on_airing.dart';
import 'package:flutter/cupertino.dart';

class TvListNotifier extends ChangeNotifier {
  var _nowOnAiringTv = <Tv>[];
  List<Tv> get nowOnAiringTv => _nowOnAiringTv;

  RequestState _onAiringState = RequestState.Empty;
  RequestState get onAiringState => _onAiringState;

  var _popularTv = <Tv>[];
  List<Tv> get poplarTv => _popularTv;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get poplarTvState => _popularTvState;

  var _topRatedTv = <Tv>[];
  List<Tv> get topRatedTv => _topRatedTv;

  RequestState _topRatedTvState = RequestState.Empty;
  RequestState get topRatedTvState => _topRatedTvState;

  String _message = '';
  String get mesage => _message;

  TvListNotifier(
      {required this.getOnAiringTv,
      required this.getPopularTv,
      required this.getTopRatedTv});

  final GetOnAiringTv getOnAiringTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  Future<void> fetchOnAiringTv() async {
    _onAiringState = RequestState.Loading;
    notifyListeners();

    final result = await getOnAiringTv.execute();
    result.fold(
      (failure) {
        _onAiringState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _onAiringState = RequestState.Loaded;
        _nowOnAiringTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchOnPopularTv() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold(
      (failure) {
        _popularTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _popularTvState = RequestState.Loaded;
        _popularTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTv() async {
    _topRatedTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTvState = RequestState.Loaded;
        _topRatedTv = tvData;
        notifyListeners();
      },
    );
  }
}
