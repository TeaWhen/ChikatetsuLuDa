import std.string;
import schema;

struct Table {
  string name;
  Schema schema;
  Index[] indexes;
}

void create_table(string name, Column[] cols, int pk) {
  //
}

void drop_table(string name) {

}
