
// Standard effect class
class Effect {
  int id;
  String name;
  String desc;
  int enabled = 0;
  List<int> effectValue;

  Effect({
    this.id,
    this.name,
    this.desc,
    this.enabled = 0,
    this.effectValue
  });

  // Convert an effect into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc' : desc,
      'enabled': enabled,
      'effectValue': effectValue,
    };
  }
}

class Patch {
  int id;
  String name;
  String desc;
  List<Effect> effects;

  Patch({
    this.id,
    this.name,
    this.desc,
    this.effects,
  });

  // Convert an effect into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'desc' : desc,
      'effects': effects,
    };
  }
}
