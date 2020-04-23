

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
  MenuCustom(name: 'Me'),
  MenuCustom(name: 'Buyer')
];

getCustomField() => <MenuCustom>[
  MenuCustom(name: 'Text'),
  MenuCustom(name: 'Date'),
  MenuCustom(name: 'Single Select'),
  MenuCustom(name: 'Multi-Select'),
];