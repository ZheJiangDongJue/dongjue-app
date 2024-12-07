import 'package:dongjue_application/orm/basic/general_entity_base.dart';
import 'package:dongjue_application/orm/interfaces/interfaces.dart';

class ChildEntityBase extends GeneralEntityBase implements IChild {
  int ParentTypeid;

  ChildEntityBase({
    this.ParentTypeid = 0,
  });
}