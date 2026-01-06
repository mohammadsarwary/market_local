import '../../../core/api/api_service.dart';
import '../../../core/repositories/local_data_source_impl.dart';
import '../models/ad_request.dart';
import '../models/ad_response.dart';
import 'ad_repository.dart';
import 'ad_repository_impl.dart';

class AdService {
  static final AdService _instance = AdService._internal();

  late AdRepository _adRepository;

  AdService._internal();

  factory AdService() {
    return _instance;
  }

  static AdService get instance => _instance;

  void initialize() {
    final apiClient = ApiService.instance.apiClient;
    final localDataSource = LocalDataSourceImpl();
    _adRepository = AdRepositoryImpl(
      apiClient: apiClient,
      localDataSource: localDataSource,
    );
  }

  AdRepository get repository => _adRepository;

  Future<AdsResponse> getAds({
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
    return await _adRepository.getAds(request);
  }

  Future<Ad> getAdDetails(String adId) async {
    return await _adRepository.getAdDetails(adId);
  }

  Future<CreateAdResponse> createAd({
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
    print('AdService: createAd() called');
    print('AdService: Title: "$title"');
    print('AdService: Description: "${description.substring(0, description.length > 50 ? 50 : description.length)}..."');
    print('AdService: Category ID: $categoryId');
    print('AdService: Price: \$$price');
    print('AdService: Location: "$location"');
    print('AdService: Coordinates: ($latitude, $longitude)');
    print('AdService: Image paths count: ${imagePaths?.length ?? 0}');
    print('AdService: Custom fields: $customFields');

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

    print('AdService: CreateAdRequest created');
    print('AdService: Request JSON: ${request.toJson()}');
    print('AdService: Calling _adRepository.createAd()...');

    final response = await _adRepository.createAd(request);

    print('AdService: CreateAd response received');
    print('AdService: Response message: ${response.message}');
    print('AdService: Response ad ID: ${response.ad.id}');
    print('AdService: Response ad title: ${response.ad.title}');
    print('AdService: Response ad price: \${response.ad.price}');

    return response;
  }

  Future<UpdateAdResponse> updateAd({
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
    return await _adRepository.updateAd(request);
  }

  Future<DeleteAdResponse> deleteAd(String adId) async {
    return await _adRepository.deleteAd(adId);
  }

  Future<MarkAsSoldResponse> markAsSold(String adId) async {
    return await _adRepository.markAsSold(adId);
  }

  Future<ToggleFavoriteResponse> toggleFavorite(String adId) async {
    return await _adRepository.toggleFavorite(adId);
  }

  Future<ImageUploadResponse> uploadAdImages(String adId, List<String> filePaths) async {
    return await _adRepository.uploadAdImages(adId, filePaths);
  }

  Future<Ad?> getCachedAd(String adId) async {
    return await _adRepository.getCachedAd(adId);
  }

  Future<void> clearAdCache(String adId) async {
    await _adRepository.clearAdCache(adId);
  }
}
