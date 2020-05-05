

import 'package:eventmanagement/model/menu_custom.dart';

getBasicEventMenu() => <MenuCustom>[
  MenuCustom(name: 'Once'),
  MenuCustom(name: 'Daily'),
  MenuCustom(name: 'Weekly'),
  MenuCustom(name: 'Custom')
];

getBasicEventPostType() => <MenuCustom>[
  MenuCustom(name: 'Public'),
  MenuCustom(name: 'Private')
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