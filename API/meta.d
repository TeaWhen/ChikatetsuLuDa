import std.stdio;
import std.conv;
import std.string;

import API.common;
import API.schema;
import CFI.buffer;
import API.index;

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
