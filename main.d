import std.stdio;
import std.string;
import std.conv;

import CLI.interp;
import API.schema;
import API.common;
import CFI.buffer;
import API.index;

void main(string args[]) {
  writeln("Welcome to the Chikatetsu monitor. Command ends with “;”.");
  load_meta();
  load_tables();
  handler();
}

void load_meta() {
  auto f = load_file(META_FILE_NAME);
  foreach (line_raw; f.byLine()) {
    string line = to!string(strip(line_raw));
    if (line != "") {
      writeln(line);
      ++table_names.length;
      table_names[table_names.length - 1] = line;
    }
  }
}

void load_tables() {
  foreach (table_name; table_names) {
    Table table;
    table.schema = load_schema(table_name);
    table.indexes = load_indexes(table_name);
    tables[table_name] = table;
  }
}
