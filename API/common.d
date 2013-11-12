import std.string;

Table[string] tables;
string[] table_names;

struct Table {
  Schema schema;
  Index[] indexes;
  Record[] records;
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
  string[] values;
}

enum PredictOPType { eq, neq, lt, gt, leq, geq }

struct Predict {
  string col_name;
  PredictOPType op_type;
  string value;
}

enum CHAR = 0;
enum INT = 1;

const bool DEBUG = false;
