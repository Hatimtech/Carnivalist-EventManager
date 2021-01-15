import 'dart:collection';
import 'dart:convert';

import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/model/addons/addon_response.dart';
import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/coupons/coupon_action_response.dart';
import 'package:eventmanagement/model/coupons/coupon_response.dart';
import 'package:eventmanagement/model/dashboard/payment_summary_response.dart';
import 'package:eventmanagement/model/event/basic/basic_response.dart';
import 'package:eventmanagement/model/event/carnivals/carnival_resonse.dart';
import 'package:eventmanagement/model/event/createticket/create_ticket_response.dart';
import 'package:eventmanagement/model/event/event_action_response.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/event_response.dart';
import 'package:eventmanagement/model/event/form/form_action_response.dart';
import 'package:eventmanagement/model/event/gallery/gallery_response.dart';
import 'package:eventmanagement/model/event/gallery/media_upload_response.dart';
import 'package:eventmanagement/model/event/settings/setting_response.dart';
import 'package:eventmanagement/model/event/settings/settings_data.dart';
import 'package:eventmanagement/model/event/settings/stripe_response.dart';
import 'package:eventmanagement/model/event/staff_event_response.dart';
import 'package:eventmanagement/model/event/tickets/ticket_action_response.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';
import 'package:eventmanagement/model/event/tickets/tickets_response.dart';
import 'package:eventmanagement/model/event/user_profile_response.dart';
import 'package:eventmanagement/model/eventdetails/event_detail_action_response.dart';
import 'package:eventmanagement/model/eventdetails/event_detail_response.dart';
import 'package:eventmanagement/model/eventdetails/tag_scanned_response.dart';
import 'package:eventmanagement/model/login/login_response.dart';
import 'package:eventmanagement/model/logindetail/login_detail_response.dart';
import 'package:eventmanagement/model/staff/create_staff_response.dart';
import 'package:eventmanagement/model/staff/staff_action_response.dart';
import 'package:eventmanagement/model/staff/staff_response.dart';
import 'package:eventmanagement/service/abstract/api_service.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';

import '../network_type.dart';
import '../restclient.dart';

class NetworkService extends NetworkType implements APIService {
  static final exampleDomain = 'carnivalist.com';
  static final baseUrl = 'https://backend.carnivalist.com';
  static final baseUrlWebview = 'https://event.carnivalist.com';

  /*'https://backend.aktv.life';*/

  static final _subUrl = '/api/';
  final _loginUrl = baseUrl + _subUrl + 'user/login';
  final _loginUrlStaff = baseUrl + _subUrl + 'user/section-leader-login';
  final _loginDetailUrl = baseUrl + _subUrl + 'user/get-user-details';
  final _signUpUrl = baseUrl + _subUrl + 'user/register';
  final _forgotPasswordUrl = baseUrl + _subUrl + 'user/forgot-password';

  //TODO EVENT
  final _ticketsListUrl = baseUrl + _subUrl + 'tickets';
  final _createTicketsUrl = baseUrl + _subUrl + 'tickets';
  final _updateTicketsUrl = baseUrl + _subUrl + 'ticket';
  final _basicUrl = baseUrl + _subUrl + 'events';
  final _stripeConnectedUrl = baseUrl + _subUrl + 'stripe/connect/get-id';
  final _carnivalListUrl =
      baseUrl + _subUrl + 'website-settings/show-categories';

  final _activeInactiveTicketUrl =
      baseUrl + _subUrl + 'toggle-active-tickets/';

  final _deleteTicketUrl = baseUrl + _subUrl + 'tickets/delete-tickets/';

  final _uploadMediaUrl = baseUrl + _subUrl + 'upload-media';
  final _eventsListUrl = baseUrl + _subUrl + 'get-events-for-managers/';
  final _staffEventsListUrl = baseUrl + _subUrl + 'get-events-for-eventstaff';

  final _paymentSummaryUrl = baseUrl + _subUrl + 'payment-summary';

  final _activeInactiveEventUrl = baseUrl + _subUrl + 'toggle-active';
  final _deleteEventUrl = baseUrl + _subUrl + 'delete-event/';

  final _addonListUrl = baseUrl + _subUrl + 'view-addons/';
  final _addonTicketListUrl = baseUrl + _subUrl + 'get-addons-for-tickets/';
  final _addonUploadUrl = baseUrl + _subUrl + 'create-addons/';

  final _deleteAddonUrl = baseUrl + _subUrl + 'delete-addon/';

  final _couponListUrl = baseUrl + _subUrl + 'get-coupons/';

  final _activeInactiveCouponUrl = baseUrl + _subUrl + 'active-toggle/';
  final _deleteCouponUrl = baseUrl + _subUrl + 'delete-coupon/';
  final _couponUploadUrl = baseUrl + _subUrl + 'save-new-coupon/';
  final _couponUpdateUrl = baseUrl + _subUrl + 'update-coupons/';

  final _eventDetailUrl = baseUrl + _subUrl + 'ticketreport/';
  final _resendTicketUrl = baseUrl + _subUrl + 'resend-ticket/';
  final _sendMailUrl = baseUrl + _subUrl + 'send-announcement/';

  final _uploadProfilePic = baseUrl + _subUrl + 'user/change-profile-pic';
  final _updateProfileUrl = baseUrl + _subUrl + 'user/change-profile-info';

  final _qrCodeScannedUrl =
      baseUrl + _subUrl + 'event/' + 'attended-EventBy-TicketId/';
  final _nfcCodeScannedUrl = baseUrl + _subUrl + 'attended-event-by-user-id/';

  final _staffListUrl = baseUrl + _subUrl + 'user/get-event-staffs';
  final _activeInactiveStaffUrl = baseUrl + _subUrl + 'user/toggle-enable/';

  final _staffCreateUrl = baseUrl + _subUrl + 'user/save-new-staff';
  final _staffEditUrl = baseUrl + _subUrl + 'user/edit-event-staffs/';

  NetworkService(RestClient rest) : super(rest);

  @override
  login(Map<String, dynamic> param, bool staffLogin) async {
    var result = await rest.post<LoginResponse>(
        staffLogin ? _loginUrlStaff : _loginUrl,
        body: param,
        encoding: Encoding.getByName("utf-8"));

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = LoginResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  loginDetail(String authToken) async {
    var headers = {
      'Authorization': authToken,
    };

    var result = await rest.get<LoginDetailResponse>(_loginDetailUrl, headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = LoginDetailResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  signUp(Map<String, dynamic> param) async {
    var result = await rest.post<LoginResponse>(_signUpUrl,
        body: param, encoding: Encoding.getByName("utf-8"));

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = LoginResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  forgotPassword(Map<String, dynamic> param) async {
    var headers = {"Content-Type": "application/json"};

    var result = await rest.post<LoginResponse>(_forgotPasswordUrl,
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = LoginResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  basic(String authToken, EventData basicJson, {String eventDataId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<BasicResponse>(
        '$_basicUrl${eventDataId != null ? '/$eventDataId' : ''}',
        body: json.encode(basicJson),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = BasicResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  carnivals() async {
    var result = await rest.getwithoutHeader<CarnivalResonse>(_carnivalListUrl);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CarnivalResonse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  tickets(String authToken) async {
    var headers = {
      'Authorization': authToken,
    };

    var result = await rest.get<TicketsResponse>(_ticketsListUrl, headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = TicketsResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  createTicket(String authToken, Map<String, dynamic> param,
      {String ticketId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<CreateTicketResponse>(
        '${ticketId != null ? _updateTicketsUrl : _createTicketsUrl}${ticketId != null ? '/$ticketId' : ''}',
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CreateTicketResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  activeInactiveTicket(String authToken, bool isActive, String ticketId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<TicketActionResponse>(
        '$_activeInactiveTicketUrl$ticketId/$isActive', headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = TicketActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  deleteTicket(String authToken, String ticketId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<TicketActionResponse>(
        '$_deleteTicketUrl$ticketId', headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = TicketActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  createNewFormField(String authToken, EventData eventDataWithForm,
      {String eventDataId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<FormActionResponse>(
        '$_basicUrl${eventDataId != null ? '/$eventDataId' : ''}',
        body: json.encode(eventDataWithForm),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = FormActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  uploadGalleryMedia(String authToken, String mediaPath) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(_uploadMediaUrl));

    var headers = {
      'Authorization': authToken,
      "Content-Type": "multipart/form-data;"
    };

    request.headers.addAll(headers);

    String mediaName;

    if (isValid(mediaPath)) {
      mediaName = mediaPath
          .split("/")
          .last;

      //create multipart using filepath, string or bytes
      var multipartFile = await http.MultipartFile.fromPath("file", mediaPath,
          filename: mediaName, contentType: MediaType.parse('image/jpeg'));

      //add multipart to request
      request.files.add(multipartFile);
    }

    var result = await rest.multipartUpload<MediaUploadResponse>(request);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = MediaUploadResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  createGalleryData(String authToken, EventData eventData,
      {String eventDataId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<GalleryResponse>(
        '$_basicUrl${eventDataId != null ? '/$eventDataId' : ''}',
        body: json.encode(eventData),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = GalleryResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  uploadSetting(String authToken, SettingData settingData,
      {String eventDataId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<SettingResponse>(
        '$_basicUrl${eventDataId != null ? '/$eventDataId' : ''}',
        body: json.encode(settingData),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = SettingResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  checkStripeConnected(String authToken) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<StripeResponse>(_stripeConnectedUrl, headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = StripeResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  getAllEvents(String authToken, String userId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result =
    await rest.get<EventResponse>('$_eventsListUrl$userId', headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = EventResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  getAllEventsForStaff(String authToken) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result =
    await rest.get<StaffEventResponse>(_staffEventsListUrl, headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = StaffEventResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  getPaymentSummary(String authToken) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var hashMap = HashMap<String, String>();
    hashMap.putIfAbsent("eventId", () => "ns");
    hashMap.putIfAbsent("time", () => "ns");
    var result = await rest.post<PaymentSummaryResponse>(_paymentSummaryUrl,
        headers: headers, body: json.encode(hashMap));

    if (result.networkServiceResponse.responseCode == ok200) {
      var res =
      PaymentSummaryResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  deleteEvent(String authToken, String eventId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<EventActionResponse>(
        '$_deleteEventUrl$eventId', headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = EventActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  activeInactiveEvent(String authToken, Map<String, dynamic> param,
      String eventId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<EventActionResponse>(_activeInactiveEventUrl,
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = EventActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  getAllAddons(String authToken, bool assigning) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<List<Addon>>(
        assigning ? _addonTicketListUrl : _addonListUrl, headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      final addonListIterable = json.decode(result.mappedResult) as Iterable;

      if (addonListIterable != null) {
        final addonList = addonListIterable
            .map((addonMap) => Addon.fromJson(addonMap))
            .toList();
        result.networkServiceResponse.response = addonList;
      }
    }
    return result.networkServiceResponse;
  }

  @override
  uploadAddon(String authToken, Addon addon) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<AddonResponse>(_addonUploadUrl,
        body: json.encode(addon),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = AddonResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  assignAddon(String authToken, Ticket ticket, {String ticketId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<CreateTicketResponse>(
        '${ticketId != null
            ? _updateTicketsUrl
            : _createTicketsUrl}${ticketId != null ? '/$ticketId' : ''}',
        body: json.encode(ticket),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CreateTicketResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  deleteAddon(String authToken, String addonId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<AddonResponse>('$_deleteAddonUrl$addonId',
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = AddonResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  getAllCoupons(String authToken) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<CouponResponse>(_couponListUrl, headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      final res = CouponResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  activeInactiveCoupons(String authToken, String couponId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<CouponActionResponse>(
        '$_activeInactiveCouponUrl$couponId', headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CouponActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  deleteCoupon(String authToken, String couponId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<CouponActionResponse>(
        '$_deleteCouponUrl$couponId',
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CouponActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  uploadCoupon(String authToken, Coupon coupon) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<CouponResponse>(
        coupon.couponId != null
            ? '$_couponUpdateUrl${coupon.couponId}'
            : _couponUploadUrl,
        body: json.encode(coupon),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CouponResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  getEventDetail(String authToken, String eventId) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<EventDetailResponse>(
        '$_eventDetailUrl$eventId', headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      final res =
      EventDetailResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  attendeesResendTicket(String authToken, Map<String, dynamic> param) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<EventDetailActionResponse>(_resendTicketUrl,
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res =
      EventDetailActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  attendeesSendMail(String authToken, Map<String, dynamic> param) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<EventDetailActionResponse>(_sendMailUrl,
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res =
      EventDetailActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  uploadProfilePic(String authToken, String mediaPath) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse(_uploadProfilePic));

    var headers = {
      'Authorization': authToken,
      "Content-Type": "multipart/form-data;"
    };

    request.headers.addAll(headers);

    String mediaName;

    if (isValid(mediaPath)) {
      mediaName = mediaPath
          .split("/")
          .last;

      //create multipart using filepath, string or bytes
      var multipartFile = await http.MultipartFile.fromPath("file", mediaPath,
          filename: mediaName, contentType: MediaType.parse('image/jpeg'));

      //add multipart to request
      request.files.add(multipartFile);
    }

    var result = await rest.multipartUpload<UserProfileResponse>(request);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = UserProfileResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }

  @override
  updateUserDetails(String authToken, Map<String, dynamic> param) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<UserProfileResponse>(_updateProfileUrl,
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = UserProfileResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  uploadTagScanned(String authToken, Map<String, dynamic> param,
      bool isNFC) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<TagScannedResponse>(
        isNFC ? _nfcCodeScannedUrl : _qrCodeScannedUrl,
        body: json.encode(param),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = TagScannedResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  getAllStaffs(String authToken) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<StaffResponse>(_staffListUrl, headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      final res = StaffResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  activeInactiveStaff(String authToken, String staffId, bool enable) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.get<StaffActionResponse>(
        '$_activeInactiveStaffUrl$staffId/$enable', headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = StaffActionResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }
    return result.networkServiceResponse;
  }

  @override
  createStaff(String authToken, Map<String, dynamic> staff,
      {String staffId}) async {
    var headers = {
      'Authorization': authToken,
      "Content-Type": "application/json"
    };

    var result = await rest.post<CreateStaffResponse>(
        isValid(staffId) ? '$_staffEditUrl$staffId' : _staffCreateUrl,
        body: json.encode(staff),
        encoding: Encoding.getByName("utf-8"),
        headers: headers);

    if (result.networkServiceResponse.responseCode == ok200) {
      var res = CreateStaffResponse.fromJson(json.decode(result.mappedResult));
      result.networkServiceResponse.response = res;
    }

    return result.networkServiceResponse;
  }
}
