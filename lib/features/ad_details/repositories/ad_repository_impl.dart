import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/repositories/local_data_source.dart';
import '../models/ad_request.dart';
import '../models/ad_response.dart';
import 'ad_repository.dart';

class AdRepositoryImpl extends BaseRepository implements AdRepository {
  final ApiClient apiClient;
  final LocalDataSource localDataSource;

  AdRepositoryImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<AdsResponse> getAds(GetAdsRequest request) async {
    return handleException(() async {
      final response = await apiClient.get(
        AdEndpoints.ads,
        queryParameters: request.toJson(),
      );
      return AdsResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<Ad> getAdDetails(String adId) async {
    return handleException(() async {
      try {
        final endpoint = AdEndpoints.adDetails.replaceAll('{ad}', adId);
        final response = await apiClient.get(endpoint);
        final ad = Ad.fromJson(response as Map<String, dynamic>);
        await cacheAd(ad);
        return ad;
      } catch (e) {
        final cached = await getCachedAd(adId);
        if (cached != null) {
          return cached;
        }
        rethrow;
      }
    });
  }

  @override
  Future<CreateAdResponse> createAd(CreateAdRequest request) async {
    return handleException(() async {
      final response = await apiClient.post(
        AdEndpoints.createAd,
        data: request.toJson(),
      );
      return CreateAdResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<UpdateAdResponse> updateAd(UpdateAdRequest request) async {
    return handleException(() async {
      final endpoint = AdEndpoints.updateAd.replaceAll('{ad}', request.adId);
      final response = await apiClient.put(
        endpoint,
        data: request.toJson(),
      );
      return UpdateAdResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<DeleteAdResponse> deleteAd(String adId) async {
    return handleException(() async {
      final endpoint = AdEndpoints.deleteAd.replaceAll('{ad}', adId);
      final response = await apiClient.delete(endpoint);
      await clearAdCache(adId);
      return DeleteAdResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<MarkAsSoldResponse> markAsSold(String adId) async {
    return handleException(() async {
      final endpoint = AdEndpoints.markAsSold.replaceAll('{ad}', adId);
      final response = await apiClient.post(endpoint);
      return MarkAsSoldResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<ToggleFavoriteResponse> toggleFavorite(String adId) async {
    return handleException(() async {
      final endpoint = AdEndpoints.toggleFavorite.replaceAll('{ad}', adId);
      final response = await apiClient.post(endpoint);
      return ToggleFavoriteResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<ImageUploadResponse> uploadAdImages(String adId, List<String> filePaths) async {
    return handleException(() async {
      final files = <MultipartFile>[];
      for (final filePath in filePaths) {
        files.add(await MultipartFile.fromFile(filePath));
      }

      final endpoint = AdEndpoints.uploadImages.replaceAll('{ad}', adId);
      final response = await apiClient.upload(
        endpoint,
        files: files,
      );
      return ImageUploadResponse.fromJson(response as Map<String, dynamic>);
    });
  }

  @override
  Future<void> cacheAd(Ad ad) async {
    return handleException(() async {
      await localDataSource.save('ad_${ad.id}', ad.toJson());
    });
  }

  @override
  Future<Ad?> getCachedAd(String adId) async {
    return handleException(() async {
      final cached = await localDataSource.get('ad_$adId');
      if (cached != null) {
        return Ad.fromJson(cached as Map<String, dynamic>);
      }
      return null;
    });
  }

  @override
  Future<void> clearAdCache(String adId) async {
    return handleException(() async {
      await localDataSource.delete('ad_$adId');
    });
  }
}
