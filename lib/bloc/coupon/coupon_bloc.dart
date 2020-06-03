import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eventmanagement/bloc/coupon/coupon_event.dart';
import 'package:eventmanagement/bloc/coupon/coupon_state.dart';
import 'package:eventmanagement/model/coupons/coupon.dart';
import 'package:eventmanagement/model/coupons/coupon_action_response.dart';
import 'package:eventmanagement/model/coupons/coupon_response.dart';
import 'package:eventmanagement/service/viewmodel/api_provider.dart';
import 'package:eventmanagement/utils/vars.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final ApiProvider apiProvider = ApiProvider();

  void authTokenSave(authToken) {
    add(AuthTokenSave(authToken: authToken));
  }

  void getAllCoupons({Completer<bool> downloadCompleter}) {
    add(GetAllCoupons(downloadCompleter: downloadCompleter));
  }

  void addCoupon(Coupon coupon) {
    add(AddCoupon(coupon));
  }

  void updateCoupon(Coupon coupon) {
    add(UpdateCoupon(coupon));
  }

  void deleteCoupon(String id, Function callback) {
    add(DeleteCoupon(id, callback));
  }

  void activeInactiveCoupon(String couponId, bool active, Function callback) {
    add(ActiveInactiveCoupon(couponId, active, callback));
  }

  @override
  CouponState get initialState => CouponState.initial();

  @override
  Stream<CouponState> mapEventToState(CouponEvent event) async* {
    if (event is AuthTokenSave) {
      yield state.copyWith(authToken: event.authToken);
    }

    if (event is GetAllCoupons) {
      if (event.downloadCompleter == null) yield state.copyWith(loading: true);
      getAllCouponsApi(event);
    }

    if (event is CouponListAvailable) {
      yield state.copyWith(
        loading: false,
        uiMsg: !event.success ? event.error : null,
        couponList: event.success ? event.couponList : null,
      );
    }

    if (event is AddCoupon) {
//      state.couponList.add(event.coupon);
//      yield state.copyWith(
//        couponList: List.of(state.couponList),
//      );
      yield state.copyWith(loading: true);
      getAllCouponsApi(event);
    }

    if (event is UpdateCoupon) {
//      int removeIndex =
//          state.couponList.indexWhere((coupon) => coupon.id == event.coupon.id);
//      state.couponList.removeAt(removeIndex);
//      state.couponList.insert(removeIndex, event.coupon);
//      yield state.copyWith(
//        couponList: List.of(state.couponList),
//      );
      yield state.copyWith(loading: true);
      getAllCouponsApi(event);
    }

    if (event is ActiveInactiveCoupon) {
      activeInactiveCouponsApi(event);
    }

    if (event is DeleteCoupon) {
      deleteCouponApi(event);
    }

    if (event is DeleteCouponResult) {
      if (event.success) {
        state.couponList.removeWhere((coupon) => coupon.id == event.couponId);

        yield state.copyWith(
            couponList: List.of(state.couponList),
            loading: false,
            uiMsg: event.uiMsg);
      } else {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }

    if (event is ActiveInactiveCouponResult) {
      if (event.success) {
        final coupon = state.couponList
            .firstWhere((coupon) => coupon.id == event.couponId);
        coupon.active = event.active;

        yield state.copyWith(
            couponList: List.of(state.couponList),
            loading: false,
            uiMsg: event.uiMsg);
      } else {
        yield state.copyWith(loading: false, uiMsg: event.uiMsg);
      }
    }
  }

  void getAllCouponsApi(CouponEvent event) {
    apiProvider.getAllCoupons(state.authToken).then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        var couponResponse = networkServiceResponse.response as CouponResponse;
        if (couponResponse != null && couponResponse.code == apiCodeSuccess) {
          final couponsList = couponResponse.coupons;
          add(CouponListAvailable(true, couponList: couponsList));
        }
      } else {
        add(CouponListAvailable(false,
            error: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
      }
      if (event is GetAllCoupons && event.downloadCompleter != null)
        event.downloadCompleter.complete(true);
    }).catchError((error, stack) {
      print('Error in getAllCouponsApi--->$error\n$stack');
      add(CouponListAvailable(false, error: ERR_SOMETHING_WENT_WRONG));
      if (event is GetAllCoupons && event.downloadCompleter != null)
        event.downloadCompleter.complete(false);
    });
  }

  void activeInactiveCouponsApi(ActiveInactiveCoupon event) {
    apiProvider
        .activeInactiveCoupons(state.authToken, event.couponId)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final eventActionResponse =
            networkServiceResponse.response as CouponActionResponse;

        if (eventActionResponse.code == apiCodeSuccess) {
          add(ActiveInactiveCouponResult(
            true,
            couponId: event.couponId,
            active: event.active,
            uiMsg: eventActionResponse.message,
          ));
          event.callback(eventActionResponse);
        } else {
          add(ActiveInactiveCouponResult(
            false,
            uiMsg: eventActionResponse.message ?? ERR_SOMETHING_WENT_WRONG,
          ));
          event.callback(eventActionResponse.message);
        }
      } else {
        add(ActiveInactiveCouponResult(
          false,
          uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG,
        ));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in activeInactiveCouponsApi--->$error');
      add(ActiveInactiveCouponResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }

  void deleteCouponApi(DeleteCoupon event) {
    apiProvider
        .deleteCoupon(state.authToken, event.id)
        .then((networkServiceResponse) {
      if (networkServiceResponse.responseCode == ok200) {
        final ticketActionResponse =
        networkServiceResponse.response as CouponActionResponse;
        if (ticketActionResponse.code == apiCodeSuccess) {
          add(DeleteCouponResult(true,
              couponId: event.id, uiMsg: ticketActionResponse.message));
          event.callback(ticketActionResponse);
        } else {
          add(DeleteCouponResult(false,
              uiMsg: ticketActionResponse.message ?? ERR_SOMETHING_WENT_WRONG));
          event.callback(ticketActionResponse);
        }
      } else {
        add(DeleteCouponResult(false,
            uiMsg: networkServiceResponse.error ?? ERR_SOMETHING_WENT_WRONG));
        event.callback(networkServiceResponse.error);
      }
    }).catchError((error) {
      print('Error in deleteCouponApi--->$error');
      add(DeleteCouponResult(false, uiMsg: ERR_SOMETHING_WENT_WRONG));
      event.callback(ERR_SOMETHING_WENT_WRONG);
    });
  }
}
