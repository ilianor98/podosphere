import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:podosphere/favorites.dart';
import 'package:podosphere/team_profile_banner_search.dart';
import 'package:podosphere/team_profile_next_game.dart';
import 'package:podosphere/team_profile_venue_serach.dart';

class TeamProfileSearch extends StatefulWidget {
  final int teamId;
  final String logo;
  final String teamName;
  final VoidCallback? onRemove;

  const TeamProfileSearch({
    super.key,
    required this.teamId,
    required this.logo,
    required this.teamName,
    this.onRemove,
  });

  @override
  State<TeamProfileSearch> createState() => _TeamProfileSearchState();
}

class _TeamProfileSearchState extends State<TeamProfileSearch> {
  List<Map<String, dynamic>> profile = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchTeamProfile();
    checkFavoriteStatus();
  }

  Future<void> fetchTeamProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://v3.football.api-sports.io/teams?id=${widget.teamId}',
        ),
        headers: {
          'X-Rapidapi-Key': 'aef994ca7854998686130ca1111308df',
          'X-Rapidapi-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final teamProfile = data['response'][0];
          setState(() {
            profile = [teamProfile];
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load team matches');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> checkFavoriteStatus() async {
    final teamIdString = widget.teamId.toString();
    isFavorite = await FavoritesManager.isTeamInFavorites(teamIdString);
    setState(() {});
  }

  void updateFavoriteStatus(bool newStatus) {
    setState(() {
      isFavorite = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF333333),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FavoriteButton(
                teamId: widget.teamId,
                onRemove: widget.onRemove,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  child: TeamProfileBannerSearch(
                teamId: widget.teamId,
                teamName: widget.teamName,
                logo: widget.logo,
                profileData: profile,
              )),
              SizedBox(
                height: 15,
              ),
              Container(
                  child: TeamProfileVenueSearch(
                teamName: widget.teamName,
                logo: widget.logo,
                profileData: profile,
              )),
              /*SizedBox(height: 15,),
              Container(
                child: TeamProfileCoach(teamId: widget.teamId)
              ),
              SizedBox(height: 15,),
              Container(
                child: TeamProfileSquad(teamId: widget.teamId)
              ),*/
              SizedBox(
                height: 15,
              ),
              Container(
                child: NextGame(teamId: widget.teamId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final int teamId;
  final VoidCallback? onRemove; // Add onRemove callback

  const FavoriteButton({Key? key, required this.teamId, this.onRemove})
      : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    final teamIdString = widget.teamId.toString();
    isFavorite = await FavoritesManager.isTeamInFavorites(teamIdString);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final teamIdString = widget.teamId.toString();

        if (isFavorite) {
          await FavoritesManager.removeFromFavoriteTeams(teamIdString);
          setState(() {
            isFavorite = false;
          });

          if (widget.onRemove != null) {
            widget.onRemove!(); // Invoke onRemove callback after removal
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isFavorite ? Colors.red : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            isFavorite ? 'Remove from favorites' : 'Add to favorites',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
