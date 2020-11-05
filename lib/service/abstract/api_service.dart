import 'package:eventmanagement/model/addons/addon.dart';
import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/event/event_data.dart';
import 'package:eventmanagement/model/event/settings/settings_data.dart';
import 'package:eventmanagement/model/event/tickets/tickets.dart';

abstract class APIService {
  login(Map<String, dynamic> param, bool staffLogin);

  loginDetail(String authToken);

  signUp(Map<String, dynamic> param);

  forgotPassword(Map<String, dynamic> param);

  basic(String authToken, EventData basicJson, {String eventDataId});

  carnivals();

  tickets(String authToken);

  createTicket(String authToken, Map<String, dynamic> param, {String ticketId});

  activeInactiveTicket(String authToken, bool active, String ticketId);

  deleteTicket(String authToken, String ticketId);

  createNewFormField(String authToken, EventData eventData,
      {String eventDataId});

  uploadGalleryMedia(String authToken, String mediaPath);

  createGalleryData(String authToken, EventData eventData,
      {String eventDataId});

  uploadSetting(String authToken, SettingData settingData,
      {String eventDataId});

  getAllEvents(String authToken, String userId);

  getAllEventsForStaff(String authToken);

  getPaymentSummary(String authToken);

  deleteEvent(String authToken, String eventId);

  activeInactiveEvent(String authToken, Map<String, dynamic> param,
      String eventId);

  uploadAddon(String authToken, Addon addon);

  getAllAddons(String authToken, bool assigning);

  assignAddon(String authToken, Ticket ticket, {String ticketId});

  deleteAddon(String authToken, String addonId);

  getAllCoupons(String authToken);

  activeInactiveCoupons(String authToken, String couponId);

  deleteCoupon(String authToken, String couponId);

  uploadCoupon(String authToken, Coupon coupon);

  getEventDetail(String authToken, String eventId);

  attendeesResendTicket(String authToken, Map<String, dynamic> param);

  attendeesSendMail(String authToken, Map<String, dynamic> param);

  uploadProfilePic(String authToken, String mediaPath);

  updateUserDetails(String authToken, Map<String, dynamic> param);

  uploadTagScanned(String authToken, Map<String, dynamic> param, bool isNFC);

  getAllStaffs(String authToken);

  activeInactiveStaff(String authToken, String staffId, bool enable);

  createStaff(String authToken, Map<String, dynamic> staff, {String staffId});
}
