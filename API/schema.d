import std.string;

enum CHAR = 0;
enum INT = 1;

struct Column {
  string name;
  int type;
  int size;
  bool is_unique;
}

struct Schema {
  Column[] cols;
  int pk;
}

void create_schema() {

}

void drop_schema() {

}
