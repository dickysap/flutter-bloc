import 'package:core/common/constants.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/tv_search_notifier.dart';
import '../widgets/tv_card_list.dart';

class SearchTv extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';
  const SearchTv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (value) {
                Provider.of<TvSearchNotiefier>(context, listen: false)
                    .fetchSearchTv(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            Consumer<TvSearchNotiefier>(
              builder: (context, data, child) {
                if (data.state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.state == RequestState.Loaded) {
                  final result = data.searchResult;
                  return Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      final tvResult = data.searchResult[index];
                      return TvCard(tvResult);
                    },
                    itemCount: result.length,
                  ));
                } else {
                  return Expanded(child: Container());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
