import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/model/menu_custom.dart';
import 'package:flutter/material.dart';

getBasicEventFrequency() =>
    <MenuCustom>[
      MenuCustom(name: 'Once', value: 'Occurs once'),
      MenuCustom(name: 'Daily', value: 'Daily'),
      MenuCustom(name: 'Weekly', value: 'Weekly'),
      MenuCustom(name: 'Custom', value: 'Custom')
    ];

getBasicEventPrivacy() =>
    <MenuCustom>[
      MenuCustom(name: 'Public', value: 'public'),
      MenuCustom(name: 'Private', value: 'private')
    ];

getPaymentType() => <MenuCustom>[
  MenuCustom(name: 'Me', value: 'me'),
  MenuCustom(name: 'Buyer', value: 'buyer')
];

getCustomField() => <MenuCustom>[
  MenuCustom(name: 'Text', value: 'text'),
  MenuCustom(name: 'Date', value: 'date'),
  MenuCustom(name: 'Single Select', value: 'singleSelect'),
  MenuCustom(name: 'Multi-Select', value: 'multiSelect'),
];

getEventFilterStatus() =>
    <MenuCustom>[
      MenuCustom(name: 'UPCOMING'),
      MenuCustom(name: 'DRAFT'),
      MenuCustom(name: 'PAST EVENTS'),
    ];

getAddonPrivacy() =>
    <MenuCustom>[
      MenuCustom(name: 'PUBLIC', value: 'PUBLIC'),
      MenuCustom(name: 'PRIVATE', value: 'PRIVATE'),
    ];

getAddonConvFeeType() =>
    <MenuCustom>[
      MenuCustom(name: 'Amount', value: 'Amount'),
      MenuCustom(name: 'Percentage', value: 'Percentage'),
    ];

getCouponDiscountType({BuildContext context}) =>
    <MenuCustom>[
      MenuCustom(
        name: context != null
            ? AppLocalizations
            .of(context)
            .labelAmount
            : 'Amount',
        value: 'amount',
      ),
      MenuCustom(
        name: context != null
            ? AppLocalizations
            .of(context)
            .labelPercentage
            : 'Percentage',
        value: 'percentage',
      ),
    ];

getCouponType({BuildContext context}) =>
    <MenuCustom>[
      MenuCustom(
        value: 'Code Discount',
        name: context != null
            ? AppLocalizations
            .of(context)
            .labelCreateDiscountCoupon
            : 'Code Discount',
      ),
      MenuCustom(
        value: 'Group Discount',
        name: context != null
            ? AppLocalizations
            .of(context)
            .labelCreateGroupCoupon
            : 'Group Discount',
      ),
      MenuCustom(
        value: 'Flat Discount',
        name: context != null
            ? AppLocalizations
            .of(context)
            .labelCreateFlatCoupon
            : 'Flat Discount',
      ),
      MenuCustom(
        value: 'Loyalty Discount',
        name: context != null
            ? AppLocalizations
            .of(context)
            .labelCreateLoyaltyCoupon
            : 'Loyalty Discount',
      ),
      MenuCustom(
        value: 'Affiliate Discount',
        name: context != null
            ? AppLocalizations
            .of(context)
            .labelCreateAffiliateCoupon
            : 'Affiliate Discount',
      ),
    ];
