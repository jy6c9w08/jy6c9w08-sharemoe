import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';

class ArtistDetailController extends GetxController {
  final  artist = Rx<Artist>(Artist());
  final int artistId;
  final ScrollController scrollController = ScrollController();
  static final ArtistRepository artistRepository = getIt<ArtistRepository>();

  ArtistDetailController({required this.artistId});

  Future<Artist> getArtistData() async {
    return await artistRepository.querySearchArtistById(artistId);
  }

  @override
  onInit(){
    getArtistData().then((value) {
       artist.value = value;
    });
    super.onInit();
  }
}
