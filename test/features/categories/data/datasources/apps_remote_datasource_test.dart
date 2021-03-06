import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:sieve_data_privacy_app/core/Constants/key.dart';
import 'package:sieve_data_privacy_app/features/categories/data/datasources/apps_remote_datasource.dart';
import 'package:sieve_data_privacy_app/features/categories/data/models/apps_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  AppsRemoteDatasourceImpl remoteDatasource;

  setUp(() {
    mockHttpClient = new MockHttpClient();
    remoteDatasource = new AppsRemoteDatasourceImpl(httpClient: mockHttpClient);
  });

  void mockHttpClientResponse200() {
    when(mockHttpClient.post(any, body: anyNamed('body'))).thenAnswer((_) async =>
        http.Response(fixtureReader('apps_list_fixture.json'), 200));
  }

  void mockHttpClientResponse404ServerErrorTrue() {
    when(mockHttpClient.post(any, body: anyNamed('body'))).thenAnswer((_) async =>
        http.Response(fixtureReader('login_user_server_error_true.json'), 404));
  }

  final List<AppsModel> tAppsModel = AppsModel.fromJsonList(
      json.decode(fixtureReader('apps_list_fixture.json')));

  test(
    'should perform the POST request on /apps/view_all',
        () async {
      //arrange
      mockHttpClientResponse200();
      //act
      final result = await remoteDatasource.loadApps(2);
      //assert
      verify(mockHttpClient.post(API_URL + "/apps/view_all", body: {'category_id': "2"}));
      expect(result, tAppsModel);
    },
  );

  test(
    'should perform the POST request on /apps/view_all_search',
        () async {
      //arrange
      mockHttpClientResponse200();
      //act
      final result = await remoteDatasource.loadAppsSearch();
      //assert
      verify(mockHttpClient.post(API_URL + "/apps/view_all_search"));
      expect(result, tAppsModel);
    },
  );

  test(
    'should return ServerFaliure when the response code is 404 and serverError is true',
        () async {
      //arrange
      mockHttpClientResponse404ServerErrorTrue();
      //act
      final call = remoteDatasource.loadApps;
      expect(() => call(2), throwsException);
      //assert
    },
  );
}
