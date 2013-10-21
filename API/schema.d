import std.string;

struct Column {
  string name;
  enum type;
  int size;
  bool is_unique;
}

struct Schema {
  Column[] cols;
  int pk;
}