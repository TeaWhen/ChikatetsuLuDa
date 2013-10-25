import std.string;

Table[string] tables;
string[] table_names;

struct Table {
  Schema schema;
  Index[] indexes;
}

struct Column {
  string name;
  int type;
  int size;
  bool is_unique;
}

struct Schema {
  string name;
  Column[] cols;
  int pk;
}

struct Index {
  string name;
}

struct Record {
  int column_id;
  string data;
}

enum CHAR = 0;
enum INT = 1;

const bool DEBUG = false;
