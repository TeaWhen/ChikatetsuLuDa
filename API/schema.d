import std.string;
import std.stdio;
import std.conv;

import API.common;
import CFI.file;

Schema load_schema(string name) {
  writeln("load_schema");
  Schema schema;
  string file_name = format("%s.%s", name, SCHEMA_EXTENSION);
  auto f = load_file(file_name);
  schema.name = strip(f.readln());

  ulong size = to!ulong(strip(f.readln()));
  schema.size = size;
  int length = to!int(strip(f.readln()));
  Column[] cols;
  cols.length = length;
  for (int i = 0; i < length; i++) {
    Column col;
    col.name = strip(f.readln());
    col.type = to!ColType(strip(f.readln()));
    col.size = to!int(strip(f.readln()));
    col.is_unique = to!bool(strip(f.readln()));
    cols[i] = col;
  }
  schema.cols = cols;
  schema.pk = to!int(strip(f.readln()));
  writeln(schema);
  return schema;
}

void save_schema(string name, Schema schema) {
  writeln("save_schema");
  string file_name = format("%s.%s", name, SCHEMA_EXTENSION);
  auto f = create_file(file_name);
  f.writeln(schema.name);
  f.writeln(schema.size);
  f.writeln(schema.cols.length);
  for (int i = 0; i < schema.cols.length; i++) {
    Column col = schema.cols[i];
    f.writeln(col.name);
    f.writeln(col.type);
    f.writeln(col.size);
    f.writeln(col.is_unique);
  }
  f.writeln(schema.pk);
}

void drop_schema(string name) {
  string file_name = format("%s.%s", name, SCHEMA_EXTENSION);
  delete_file(file_name);
}
