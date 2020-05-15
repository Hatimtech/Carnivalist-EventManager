import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_bloc.dart';
import 'package:eventmanagement/bloc/coupon/create/create_coupon_event.dart';
import 'package:eventmanagement/bloc/coupon/create/create_coupon_state.dart';
import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/coupons/coupon_parameters.dart';
import 'package:eventmanagement/model/coupons/coupon_response.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/vars.dart';

class CreateCouponBloc extends Bloc<CreateCouponEvent, CreateCouponState> {
  final ApiProvider apiProvider = ApiProvider();
  final CouponBloc couponBloc;
  final String couponType, couponId;

  CreateCouponBloc(this.couponBloc, this.couponType, {this.couponId});

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void createCouponDefault() {
    add(CreateCouponDefault());
  }

  void couponTypeInput(couponType) {
    add(CouponTypeInput(couponType: couponType));
  }

  void codeTypeInput(codeType) {
    add(CodeTypeInput(codeType: codeType));
  }

  void startDateTimeInput(startDateTime) {
    add(StartDateTimeInput(startDateTime: startDateTime));
  }

  void endDateTimeInput(endDateTime) {
    add(EndDateTimeInput(endDateTime: endDateTime));
  }

  void discountNameInput(discountName) {
    add(DiscountNameInput(discountName: discountName));
  }

  void codeInput(code) {
    add(CodeInput(code: code));
  }

  void discountValueInput(discountValue) {
    add(DiscountValueInput(discountValue: discountValue));
  }

  void noOfDiscountInput(noOfDiscount) {
    add(NoOfDiscountInput(noOfDiscount: noOfDiscount));
  }

  void discountTypeInput(discountType) {
    add(DiscountTypeInput(discountType: discountType));
  }

  void minQuantityInput(minQuantity) {
    add(MinQuantityInput(minQuantity: minQuantity));
  }

  void maxQuantityInput(maxQuantity) {
    add(MaxQuantityInput(maxQuantity: maxQuantity));
  }

  void affiliateEmailInput(email) {
    add(AffiliateEmailInput(email: email));
  }

  void selectEventInput(eventData) {
    add(SelectEventInput(eventData: eventData));
  }

  void selectPastEventInput(eventData) {
    add(SelectPastEventInput(eventData: eventData));
  }

  void addEventTicketInput(ticketId) {
    add(AddEventTicketInput(ticketId: ticketId));
  }

  void removeEventTicketInput(ticketId) {
    add(RemoveEventTicketInput(ticketId: ticketId));
  }

  void uploadNewCoupon(callback) {
    add(UploadCoupon(callback: callback));
  }

  @override
  CreateCouponState get initialState {
    if (couponId == null)
      return CreateCouponState.initial(couponType: couponType);
    else {
      final coupon = couponBloc.state.couponList
          .firstWhere((coupon) => coupon.id == couponId);

      final discountTypeList = getCouponDiscountType() as List<MenuCustom>;
      discountTypeList.forEach((menu) {
        if (menu.value == coupon.couponParameters.discountType)
          menu.isSelected = true;
      });
      return CreateCouponState.copyWith(coupon, discountTypeList);
    }
  }

  @override
  Stream<CreateCouponState> mapEventToState(CreateCouponEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is CreateCouponDefault && couponId == null) {
      final discountTypeList = getCouponDiscountType() as List<MenuCustom>;
      discountTypeList[0].isSelected = true;
      yield state.copyWith(discountTypeList: discountTypeList);
    }

    if (event is CouponTypeInput) {
      yield state.copyWith(couponType: event.couponType);
    }

    if (event is CodeTypeInput) {
      yield state.copyWith(codeType: event.codeType);
    }

    if (event is DiscountNameInput) {
      yield state.copyWith(discountName: event.discountName);
    }

    if (event is CodeInput) {
      yield state.copyWith(code: event.code);
    }

    if (event is StartDateTimeInput) {
      final start = event.startDateTime;
      yield state.copyWith(
          startDateTime: DateTime(start.year, start.month, start.day));
    }

    if (event is EndDateTimeInput) {
      final end = event.endDateTime;
      yield state.copyWith(endDateTime: DateTime(end.year, end.month, end.day));
    }

    if (event is DiscountValueInput) {
      yield state.copyWith(discountValue: event.discountValue);
    }

    if (event is NoOfDiscountInput) {
      yield state.copyWith(noOfDiscount: event.noOfDiscount);
    }

    if (event is DiscountTypeInput) {
      state.discountTypeList.forEach((menu) {
        if (menu == event.discountType)
          menu.isSelected = true;
        else
          menu.isSelected = false;
      });
      yield state.copyWith(discountTypeList: List.of(state.discountTypeList));
    }

    if (event is MinQuantityInput) {
      yield state.copyWith(minQuantity: event.minQuantity);
    }

    if (event is MaxQuantityInput) {
      yield state.copyWith(maxQuantity: event.maxQuantity);
    }

    if (event is AffiliateEmailInput) {
      yield state.copyWith(affiliateEmailId: event.email);
    }

    if (event is SelectEventInput) {
      state.checkedTicket?.clear();
      yield state.copyWith(
          selectedEvent: event.eventData,
          checkedTicket: List.of(state.checkedTicket));
    }

    if (event is SelectPastEventInput) {
      yield state.copyWith(selectedPastEvent: event.eventData);
    }

    if (event is AddEventTicketInput) {
      yield state.copyWith(
          checkedTicket: List.of(state.checkedTicket)..add(event.ticketId));
    }

    if (event is RemoveEventTicketInput) {
      yield state.copyWith(
          checkedTicket: List.of(state.checkedTicket)..remove(event.ticketId));
    }

    if (event is UploadCoupon) {
      yield* uploadCoupon(event);
    }

    if (event is UploadCouponResult) {
      yield state.copyWith(
        loading: false,
        uiMsg: event.uiMsg,
      );
    }
  }

  Stream<CreateCouponState> uploadCoupon(UploadCoupon event) async* {
    int errorCode = validateCouponData;
    if (errorCode > 0) {
      yield state.copyWith(uiMsg: errorCode);
      event.callback(null);
      return;
    }
    yield state.copyWith(loading: true);

    final couponToUpload = couponByType;
    apiProvider
        .uploadCoupon(state.authToken, couponToUpload)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var couponResponse = networkServiceResponse.response as CouponResponse;
        if (couponResponse.code == apiCodeSuccess) {
          if (couponId != null) {
            couponBloc.updateCoupon(couponToUpload);
          } else {
            couponBloc.addCoupon(couponToUpload);
          }
          add(UploadCouponResult(true));
          event.callback(couponResponse);
        } else {
          add(UploadCouponResult(false,
              uiMsg: couponResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(couponResponse.message);
        }
      } else {
        add(UploadCouponResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in uploadCoupon--->$error');
      add(UploadCouponResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(error);
    });
  }

  int get validateCouponData {
    final couponTypes = getCouponType() as List<MenuCustom>;
    if (couponTypes[0].value == state.couponType) {
      return validateCodeDiscountData;
    } else if (couponTypes[1].value == state.couponType) {
      return validateGroupDiscountData;
    } else if (couponTypes[2].value == state.couponType) {
      return validateFlatDiscountData;
    } else if (couponTypes[3].value == state.couponType) {
      return validateLoyaltyDiscountData;
    } else if (couponTypes[4].value == state.couponType) {
      return validateAffiliateDiscountData;
    }
    return 0;
  }

  int get validateCodeDiscountData {
    if (!isValid(state.discountName)) return ERR_DISCOUNT_NAME;
    if (state.startDateTime == null) return ERR_COUPON_START_DATE;
    if (state.endDateTime == null) return ERR_COUPON_END_DATE;
    if (state.startDateTime.isAfter(state.endDateTime))
      return ERR_COUPON_START_DATE_AFTER;
    if (!isValid(state.noOfDiscount)) return ERR_COUPON_NO_OF_DISCOUNT;
    if (int.tryParse(state.noOfDiscount) == 0)
      return ERR_COUPON_NO_OF_DISCOUNT_ZERO;
    if (!isValid(state.code)) return ERR_COUPON_CODE;
    if (!isValid(state.discountValue)) return ERR_COUPON_DISCOUNT;
    if (state.selectedEvent == null) return ERR_COUPON_EVENT_SELECTION;
    if ((state.checkedTicket?.length ?? 0) == 0)
      return ERR_COUPON_TICKET_SELECTION;

    return 0;
  }

  int get validateGroupDiscountData {
    if (!isValid(state.discountName)) return ERR_DISCOUNT_NAME;
    if (state.startDateTime == null) return ERR_COUPON_START_DATE;
    if (state.endDateTime == null) return ERR_COUPON_END_DATE;
    if (state.startDateTime.isAfter(state.endDateTime))
      return ERR_COUPON_START_DATE_AFTER;

    if (!isValid(state.noOfDiscount)) return ERR_COUPON_NO_OF_DISCOUNT;
    if (int.tryParse(state.noOfDiscount) == 0)
      return ERR_COUPON_NO_OF_DISCOUNT_ZERO;

    if (!isValid(state.minQuantity)) return ERR_COUPON_MIN_TICKET;
    if (int.tryParse(state.minQuantity) == 0) return ERR_COUPON_MIN_TICKET_ZERO;

    if (!isValid(state.maxQuantity)) return ERR_COUPON_MAX_TICKET;
    if (int.tryParse(state.maxQuantity) == 0) return ERR_COUPON_MAX_TICKET_ZERO;

    if (!isValid(state.discountValue)) return ERR_COUPON_DISCOUNT;
    if (state.selectedEvent == null) return ERR_COUPON_EVENT_SELECTION;
    if ((state.checkedTicket?.length ?? 0) == 0)
      return ERR_COUPON_TICKET_SELECTION;

    return 0;
  }

  int get validateFlatDiscountData {
    if (!isValid(state.discountName)) return ERR_DISCOUNT_NAME;
    if (state.startDateTime == null) return ERR_COUPON_START_DATE;
    if (state.endDateTime == null) return ERR_COUPON_END_DATE;
    if (state.startDateTime.isAfter(state.endDateTime))
      return ERR_COUPON_START_DATE_AFTER;

    if (!isValid(state.noOfDiscount)) return ERR_COUPON_NO_OF_DISCOUNT;
    if (int.tryParse(state.noOfDiscount) == 0)
      return ERR_COUPON_NO_OF_DISCOUNT_ZERO;

    if (!isValid(state.discountValue)) return ERR_COUPON_DISCOUNT;
    if (state.selectedEvent == null) return ERR_COUPON_EVENT_SELECTION;
    if ((state.checkedTicket?.length ?? 0) == 0)
      return ERR_COUPON_TICKET_SELECTION;

    return 0;
  }

  int get validateLoyaltyDiscountData {
    if (!isValid(state.discountName)) return ERR_DISCOUNT_NAME;
    if (state.startDateTime == null) return ERR_COUPON_START_DATE;
    if (state.endDateTime == null) return ERR_COUPON_END_DATE;
    if (state.startDateTime.isAfter(state.endDateTime))
      return ERR_COUPON_START_DATE_AFTER;

    if (!isValid(state.noOfDiscount)) return ERR_COUPON_NO_OF_DISCOUNT;
    if (int.tryParse(state.noOfDiscount) == 0)
      return ERR_COUPON_NO_OF_DISCOUNT_ZERO;

    if (!isValid(state.discountValue)) return ERR_COUPON_DISCOUNT;
    if (state.selectedEvent == null) return ERR_COUPON_EVENT_SELECTION;
    if ((state.checkedTicket?.length ?? 0) == 0)
      return ERR_COUPON_TICKET_SELECTION;
    if (state.selectedPastEvent == null) return ERR_COUPON_PAST_EVENT_SELECTION;
    return 0;
  }

  int get validateAffiliateDiscountData {
    if (!isValid(state.discountName)) return ERR_DISCOUNT_NAME;
    if (state.startDateTime == null) return ERR_COUPON_START_DATE;
    if (state.endDateTime == null) return ERR_COUPON_END_DATE;
    if (state.startDateTime.isAfter(state.endDateTime))
      return ERR_COUPON_START_DATE_AFTER;

    if (!isValid(state.noOfDiscount)) return ERR_COUPON_NO_OF_DISCOUNT;
    if (int.tryParse(state.noOfDiscount) == 0)
      return ERR_COUPON_NO_OF_DISCOUNT_ZERO;

    if (!isValid(state.affiliateEmailId)) return ERR_COUPON_AFFILIATE_EMAIL;
    if (validateEmail(state.affiliateEmailId) != null)
      return ERR_COUPON_AFFILIATE_EMAIL_VALID;

    if (!isValid(state.discountValue)) return ERR_COUPON_DISCOUNT;
    if (state.selectedEvent == null) return ERR_COUPON_EVENT_SELECTION;
    if ((state.checkedTicket?.length ?? 0) == 0)
      return ERR_COUPON_TICKET_SELECTION;

    return 0;
  }

  Coupon get couponByType {
    final couponTypes = getCouponType() as List<MenuCustom>;
    if (couponTypes[0].value == state.couponType) {
      return makeCodeDiscountCoupon;
    } else if (couponTypes[1].value == state.couponType) {
      return makeGroupDiscountCoupon;
    } else if (couponTypes[2].value == state.couponType) {
      return makeFlatDiscountCoupon;
    } else if (couponTypes[3].value == state.couponType) {
      return makeLoyaltyDiscountCoupon;
    } else if (couponTypes[4].value == state.couponType) {
      return makeAffiliateDiscountCoupon;
    }
  }

  Coupon get makeCodeDiscountCoupon {
    return Coupon(
      couponId: couponId,
      couponType: state.couponType,
      couponParameters: CouponParameters(
        codeType: 'singleCode',
        discountName: state.discountName,
        code: state.code,
        discountValue: int.tryParse(state.discountValue),
        prefix: '',
        checkedTicket: state.checkedTicket,
        startDateTime: state.startDateTime,
        endDateTime: state.endDateTime,
        noOfDiscount: int.tryParse(state.noOfDiscount),
        discountType:
            state.discountTypeList.firstWhere((menu) => menu.isSelected).value,
        selectedEvent: state.selectedEvent,
      ),
    );
  }

  Coupon get makeGroupDiscountCoupon {
    return Coupon(
      couponId: couponId,
      couponType: state.couponType,
      couponParameters: CouponParameters(
        discountName: state.discountName,
        code: state.code,
        discountValue: int.tryParse(state.discountValue),
        prefix: '',
        checkedTicket: state.checkedTicket,
        startDateTime: state.startDateTime,
        endDateTime: state.endDateTime,
        noOfDiscount: int.tryParse(state.noOfDiscount),
        minQuantity: int.tryParse(state.minQuantity),
        maxQuantity: int.tryParse(state.maxQuantity),
        discountType:
            state.discountTypeList.firstWhere((menu) => menu.isSelected).value,
        selectedEvent: state.selectedEvent,
      ),
    );
  }

  Coupon get makeFlatDiscountCoupon {
    return Coupon(
      couponId: couponId,
      couponType: state.couponType,
      couponParameters: CouponParameters(
        discountName: state.discountName,
        discountValue: int.tryParse(state.discountValue),
        prefix: '',
        checkedTicket: state.checkedTicket,
        startDateTime: state.startDateTime,
        endDateTime: state.endDateTime,
        noOfDiscount: int.tryParse(state.noOfDiscount),
        discountType:
            state.discountTypeList.firstWhere((menu) => menu.isSelected).value,
        selectedEvent: state.selectedEvent,
      ),
    );
  }

  Coupon get makeLoyaltyDiscountCoupon {
    return Coupon(
      couponId: couponId,
      couponType: state.couponType,
      couponParameters: CouponParameters(
        discountName: state.discountName,
        discountValue: int.tryParse(state.discountValue),
        prefix: '',
        checkedTicket: state.checkedTicket,
        startDateTime: state.startDateTime,
        endDateTime: state.endDateTime,
        noOfDiscount: int.tryParse(state.noOfDiscount),
        discountType:
            state.discountTypeList.firstWhere((menu) => menu.isSelected).value,
        selectedEvent: state.selectedEvent,
        selectedPastEvent: state.selectedPastEvent,
      ),
    );
  }

  Coupon get makeAffiliateDiscountCoupon {
    return Coupon(
      couponId: couponId,
      couponType: state.couponType,
      couponParameters: CouponParameters(
        discountName: state.discountName,
        discountValue: int.tryParse(state.discountValue),
        prefix: '',
        checkedTicket: state.checkedTicket,
        startDateTime: state.startDateTime,
        endDateTime: state.endDateTime,
        noOfDiscount: int.tryParse(state.noOfDiscount),
        affiliateEmailId: state.affiliateEmailId,
        discountType:
            state.discountTypeList.firstWhere((menu) => menu.isSelected).value,
        selectedEvent: state.selectedEvent,
      ),
    );
  }
}
