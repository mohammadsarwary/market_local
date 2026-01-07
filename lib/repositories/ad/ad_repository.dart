import '../../models/ad/ad_models.dart';

abstract class AdRepository {
  Future<AdsResponse> getAds(GetAdsRequest request);

  Future<Ad> getAdDetails(String adId);

  Future<CreateAdResponse> createAd(CreateAdRequest request);

  Future<UpdateAdResponse> updateAd(UpdateAdRequest request);

  Future<DeleteAdResponse> deleteAd(String adId);

  Future<MarkAsSoldResponse> markAsSold(String adId);

  Future<ToggleFavoriteResponse> toggleFavorite(String adId);

  Future<ImageUploadResponse> uploadAdImages(String adId, List<String> filePaths);

  Future<void> cacheAd(Ad ad);

  Future<Ad?> getCachedAd(String adId);

  Future<void> clearAdCache(String adId);

  // Convenience methods
  Future<AdsResponse> getAdsPaginated({
    int page = 1,
    int limit = 20,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? location,
    double? radius,
    String? sortBy,
  });

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
  });

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
  });
}
