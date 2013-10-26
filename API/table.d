import std.string;
import std.stdio;

import API.schema;
import API.index;
import CFI.buffer;
import API.common;

void create_table(string name, Column[] cols, int pk) {
  if (DEBUG) {
    writeln(name);
    for (int i = 0; i < cols.length; i++) {
      Column col = cols[i];
      writeln(col.name, " ", col.type, " ", col.size, " ", col.is_unique);
    }
    writeln(pk);
  }

  auto f = edit_file(META_FILE_NAME);
  f.writeln(name);

  Table table;
  table.schema.name = name;
  table.schema.cols = cols;
  table.schema.pk = pk;
  tables[name] = table;

  save_schema(name, table.schema);
}

void drop_table(string name) {
  writeln("dropping table ", name);

  bool is_table_exist = tables.remove(name);
  if (is_table_exist == false) {
    writeln("table doesn't exist.");
  }
  else {
    int ret = delete_file(name);
    if (ret != 0) {
      writeln("something is wrong.");
    }
  }
}
