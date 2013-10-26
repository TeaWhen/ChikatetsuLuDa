import std.string;
import std.stdio;

import API.common;

void insert_record(string table_name, string[] values) {
  writeln("inserting ? from ", table_name);
  if (table_name in tables) {
    // TODO: type checking...
    ulong length = tables[table_name].records.length;
    ++tables[table_name].records.length;
    Record record;
    record.values = values;
    tables[table_name].records[length] = record;
  }
  else {
    writeln(table_name, " doesn't exist.");
  }
}

void delete_record(string table_name) {
  writeln("deleting * from ", table_name);
}

void select_record(string table_name) {
  writeln("selecting * from ", table_name);
}
