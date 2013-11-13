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
}

enum ColType { CKint, CKfloat, CKchar }

struct Column {
  string name;
  ColType type;
  int size;
  bool is_unique;
}

struct Record {
  string[] values;
}

enum PredictOPType { eq, neq, lt, gt, leq, geq }

struct Predict {
  int col_index;
  PredictOPType op_type;
  string value;
}

struct Index {
  string name;
  string table_name;
  ulong col_index;
  BTree btree;
}

const bool DEBUG = false;
