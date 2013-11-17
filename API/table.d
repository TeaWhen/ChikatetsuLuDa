import std.string;
import std.stdio;

import API.schema;
import API.index;
import CFI.file;
import API.common;
import API.index;
import API.meta;

void create_table(string name, Column[] cols, int pk) {
  auto f = append_file(META_FILE_NAME);
  f.writeln(name);

  Table table;
  table.schema.name = name;
  table.schema.cols = cols;

  table.schema.size = 0;
  foreach (col; table.schema.cols) {
    switch (col.type) {
      case ColType.CKint:
        table.schema.size += 4;
        break;
      case ColType.CKfloat:
        table.schema.size += float.sizeof;
        break;
      case ColType.CKchar:
        table.schema.size += 1 * col.size;
        break;
      default:
        writeln("error");
    }
  }
  writeln(table.schema.size);
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
    drop_schema(name);
    // TODO drop all indexes
    drop_index(name);
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
  }
}
