import std.stdio;
import std.conv;
import std.string;

import API.common;
import API.schema;
import CFI.buffer;
import API.index;
import API.record;

void load_meta() {
  auto f = load_file(META_FILE_NAME);
  foreach (line_raw; f.byLine()) {
    string line = to!string(strip(line_raw));
    if (line != "") {
      ++table_names.length;
      table_names[table_names.length - 1] = line;
    }
  }
}

void load_tables() {
  foreach (table_name; table_names) {
    Table table;
    table.schema = load_schema(table_name);
    string file_name = format("%s.%s", table_name, INDEX_EXTENSION);
    string[] index_name_list = load_index_list(table_name);
    writeln(index_name_list);
    foreach (index_name; index_name_list) {
      table.indexes = load_indexes(index_name, table_name);
    }
    table.records = load_records(table_name, table.schema);
    tables[table_name] = table;
  }
}
