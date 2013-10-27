import std.string;

Table[string] tables;
string[] table_names;

struct Table {
  Schema schema;
  Index[] indexes;
}

struct Schema {
  string name;
  Column[] cols;
  int pk;
}

struct Index {
  string name;
}

struct Column {
  string name;
  int type;
  int size;
  bool is_unique;
}

struct Record {
  int column_id;
  string data;
}

interface Cell {
  bool less_than(Cell other);
  bool greater_than(Cell other);
  string value();
}

class CKInt : Cell {
  private int cell_value;
  override bool less_than(Cell other) {
    //
  }
}

enum CHAR = 0;
enum INT = 1;

const bool DEBUG = false;
