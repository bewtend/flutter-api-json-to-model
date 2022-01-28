import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'model.dart';

void main() => runApp(const MainPage());

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final String url = 'https://run.mocky.io/v3/ba4bbc49-5cc2-4792-ba11-f82f2c6b3df7';

  Future<List<User>?> _service() async {
    try {
      final response = await Dio().get(url);
      final data = response.data;
      if (data is List) {
        return data.map((element) => User.fromJson(element)).toList();
      }
    } catch (e) {
      Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _service();
  }

  @override
  Widget build(BuildContext context) {
    const String _materialTitle = 'Flutter API Service to Models';
    const String _appBarTitle = 'Users';
    const String _noData = 'No Data';

    return MaterialApp(
      title: _materialTitle,
      theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: Theme.of(context).textTheme.headline5,
        centerTitle: true,
      )),
      home: Scaffold(
        appBar: AppBar(title: const Text(_appBarTitle)),
        body: FutureBuilder(
          future: _service(),
          builder: (context, AsyncSnapshot<List<User>?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data?[index].avatar ?? _noData),
                        ),
                        title: Text('${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}'),
                        subtitle: Text(snapshot.data?[index].email ?? _noData),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text(_noData));
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
