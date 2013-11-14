import std.string;

import API.btree;

Table[string] tables;
string[] table_names;

struct Table {
  Schema schema;
  Index[] indexes;
  Block[] blocks;
  ulong block_size = 128;
}

struct Schema {
  string name;
  Column[] cols;
  int pk;
  ulong size;
}

enum ColType { CKint, CKfloat, CKchar }

struct Column {
  string name;
  ColType type;
  int size;
  bool is_unique;
}

struct Block {
  Record[] records;
  bool loaded;
  ulong size;
};

struct Record {
  string[] values;
}

enum PredictOPType { eq, neq, lt, gt, leq, geq }

struct Predict {
  ulong col_index;
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
