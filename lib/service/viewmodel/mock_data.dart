

import 'package:eventmanagement/model/menu_custom.dart';

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