import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_buds/constants.dart';
import 'package:social_buds/models/user_model.dart';
import 'package:social_buds/screens/profile_screen.dart';
import 'package:social_buds/services/database_service.dart';

class SearchScreen extends StatefulWidget {
  final String currentUserId;

  const SearchScreen({super.key, required this.currentUserId,});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? _users;
  TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture.isEmpty
            ? AssetImage('assets/images/default_pic.png')
            : NetworkImage(user.profilePicture) as ImageProvider,
      ),
      title: Text(user.username!),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileScreen(
                  currentUserId: widget.currentUserId,
                  visitedUserId: user.id,
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KTweeterColor,
        centerTitle: true,
        elevation: 4,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            hintText: 'Search user',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                clearSearch();
              },
            ),
            filled: true,
          ),
          onChanged: (input) {
            if (input.isNotEmpty) {
              setState(() {
                _users = DatabaseServices.searchUsers(input);
              });
            }
          },
        ),
      ),
      body: _users == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 200),
                  Text(
                    'Search User...',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          : FutureBuilder(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: KTweeterColor,),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text('No users found!'),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel user =
                          UserModel.fromDoc(snapshot.data.docs[index]);
                      return buildUserTile(user);
                    });
              }),
    );
  }
}
