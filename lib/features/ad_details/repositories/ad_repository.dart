import '../models/ad_request.dart';
import '../models/ad_response.dart';

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
}
