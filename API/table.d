import std.string;
import std.stdio;

import API.schema;
import API.index;
import CFI.buffer;
import API.common;
import API.index;
import API.meta;

void create_table(string name, Column[] cols, int pk) {
  if (DEBUG) {
    writeln(name);
    for (int i = 0; i < cols.length; i++) {
      Column col = cols[i];
      writeln(col.name, " ", col.type, " ", col.size, " ", col.is_unique);
    }
    writeln(pk);
  }

  auto f = append_file(META_FILE_NAME);
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
    delete_file(META_FILE_NAME);
    auto f = create_file(META_FILE_NAME);
    for (int i = 0; i < table_names.length; i++) {
      if (table_names[i] == name) {
        continue;
      }
      else {
        f.writeln(table_names[i]);
      }
    }
    load_meta();
    drop_schema(name);
    drop_index(name);
  }
}
