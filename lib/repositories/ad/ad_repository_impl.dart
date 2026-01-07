import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/repositories/base_repository.dart';
import '../../../core/repositories/local_data_source.dart';
import '../../models/ad/ad_models.dart';
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
    print('AdRepositoryImpl: createAd() called');
    print('AdRepositoryImpl: Endpoint: ${AdEndpoints.createAd}');
    print('AdRepositoryImpl: Request data: ${request.toJson()}');

    return handleException(() async {
      print('AdRepositoryImpl: Calling apiClient.post()...');
      final response = await apiClient.post(
        AdEndpoints.createAd,
        data: request.toJson(),
      );

      print('AdRepositoryImpl: API response received');
      print('AdRepositoryImpl: Status code: ${response.statusCode}');
      print('AdRepositoryImpl: Response data: ${response.data}');

      final createAdResponse = CreateAdResponse.fromJson(response as Map<String, dynamic>);
      print('AdRepositoryImpl: CreateAdResponse parsed successfully');
      print('AdRepositoryImpl: Response message: ${createAdResponse.message}');
      print('AdRepositoryImpl: Ad ID: ${createAdResponse.ad.id}');

      return createAdResponse;
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

  @override
  Future<AdsResponse> getAdsPaginated({
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? location,
    double? radius,
    String? sortBy,
  }) async {
    final request = GetAdsRequest(
      page: page,
      limit: limit,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      location: location,
      radius: radius,
      sortBy: sortBy,
    );
    return await getAds(request);
  }

  @override
  Future<CreateAdResponse> createAdWithDetails({
    required String title,
    required String description,
    required String categoryId,
    required double price,
    required String location,
    required double latitude,
    required double longitude,
    List<String>? imagePaths,
    Map<String, dynamic>? customFields,
  }) async {
    print('AdRepositoryImpl: createAdWithDetails() called');
    print('AdRepositoryImpl: Title: "$title"');
    print('AdRepositoryImpl: Description: "${description.substring(0, description.length > 50 ? 50 : description.length)}..."');
    print('AdRepositoryImpl: Category ID: $categoryId');
    print('AdRepositoryImpl: Price: \$$price');
    print('AdRepositoryImpl: Location: "$location"');
    print('AdRepositoryImpl: Coordinates: ($latitude, $longitude)');
    print('AdRepositoryImpl: Image paths count: ${imagePaths?.length ?? 0}');
    print('AdRepositoryImpl: Custom fields: $customFields');

    final request = CreateAdRequest(
      title: title,
      description: description,
      categoryId: categoryId,
      price: price,
      location: location,
      latitude: latitude,
      longitude: longitude,
      imagePaths: imagePaths,
      customFields: customFields,
    );

    print('AdRepositoryImpl: CreateAdRequest created');
    print('AdRepositoryImpl: Request JSON: ${request.toJson()}');
    print('AdRepositoryImpl: Calling createAd()...');

    final response = await createAd(request);

    print('AdRepositoryImpl: CreateAd response received');
    print('AdRepositoryImpl: Response message: ${response.message}');
    print('AdRepositoryImpl: Response ad ID: ${response.ad.id}');
    print('AdRepositoryImpl: Response ad title: ${response.ad.title}');
    print('AdRepositoryImpl: Response ad price: \${response.ad.price}');

    return response;
  }

  @override
  Future<UpdateAdResponse> updateAdWithDetails({
    required String adId,
    required String title,
    required String description,
    required String categoryId,
    required double price,
    required String location,
    required double latitude,
    required double longitude,
    Map<String, dynamic>? customFields,
  }) async {
    final request = UpdateAdRequest(
      adId: adId,
      title: title,
      description: description,
      categoryId: categoryId,
      price: price,
      location: location,
      latitude: latitude,
      longitude: longitude,
      customFields: customFields,
    );
    return await updateAd(request);
  }
}
