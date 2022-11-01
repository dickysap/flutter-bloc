import '../../core/lib/common/network_info.dart';
import '../../core/lib/data/datasources/db/database_helper.dart';
import '../../core/lib/data/datasources/db/tv_database_helper.dart';
import '../../core/lib/data/datasources/movie_local_data_source.dart';
import '../../core/lib/data/datasources/movie_remote_data_source.dart';
import '../../core/lib/data/datasources/tv_local_data_source.dart';
import '../../core/lib/data/datasources/tv_remote_data_source.dart';
import '../../core/lib/domain/repositories/movie_repository.dart';
import '../../core/lib/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  TvRepository,
  MovieRemoteDataSource,
  TvRemoteDataSource,
  MovieLocalDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  TvDatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
