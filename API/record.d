import std.string;
import std.stdio;

struct Record {
  int column_id;
  string data;
}

void insert_record(string table_name) {
  writeln("inserting ? from ", table_name);
}

void delete_record(string table_name) {
  writeln("deleting * from ", table_name);
}

void select_record(string table_name) {
  writeln("selecting * from ", table_name);
}
