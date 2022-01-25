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
  String url = 'https://run.mocky.io/v3/ba4bbc49-5cc2-4792-ba11-f82f2c6b3df7';
  Future<List<Users>?> _service() async {
    try {
      final response = await Dio().get(url);
      final data = response.data;
      if (data is List) {
        return data.map((element) => Users.fromJson(element)).toList();
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
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Kullanıcılar',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: FutureBuilder(
            future: _service(),
            builder: (context, AsyncSnapshot<List<Users>?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data?[index].avatar ?? 'No Data'),
                        ),
                        title: Text(
                            '${snapshot.data?[index].firstName} ${snapshot.data?[index].lastName}'),
                        subtitle:
                            Text(snapshot.data?[index].email ?? 'No Data'),
                      );
                    },
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
