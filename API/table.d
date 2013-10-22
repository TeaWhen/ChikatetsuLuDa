import std.string;
import std.stdio;

import schema;
import index;

struct Table {
  string name;
  Schema schema;
  Index[] indexes;
}

void create_table(string name, Column[] cols, int pk) {
  writeln(name);
  for (int i = 0; i < cols.length; i++) {
    Column col = cols[i];
    writeln(col.name);
  }
  writeln(pk);
}

void drop_table(string name) {
  writeln("dropping table ", name);
}
