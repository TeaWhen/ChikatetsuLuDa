import std.string;

import API.btree;

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
  uint size;
}

enum ColType { CKint = 0, CKchar = 1, CKfloat = 2 }

struct Column {
  string name;
  ColType type;
  int size;
  bool is_unique;
  ulong total;
}

struct Record {
  string[] values;
  bool deleted;
}

enum PredictOPType { eq, neq, lt, gt, leq, geq }

struct Predict {
  uint col_index;
  PredictOPType op_type;
  string value;
}

struct Index {
  string name;
  string table_name;
  uint col_index;
  BTree btree;
}

const bool DEBUG = false;
