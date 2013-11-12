import std.string;
import std.stdio;

import API.common;
import CFI.buffer;

void insert_record(string table_name, string[] values) {
  if (table_name in tables) {
    // TODO: type checking...
    Record record;
    record.values = values;
    tables[table_name].records ~= record;

    string file_name = format("%s.%s", table_name, RECORD_EXTENSION);
    File f = append_file(file_name);
    for (int i = 0; i < values.length; i++) {
      f.writeln(values[i]);
    }
  }
  else {
    writeln(table_name, " doesn't exist.");
  }
}

void delete_record(string table_name) {
  writeln("deleting * from ", table_name);
}

Record[] select_record(string table_name) {
  writeln("selecting * from ", table_name);
  Record[] records = tables[table_name].records;
  return records;
}
