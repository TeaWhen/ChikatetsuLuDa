import std.string;
import std.stdio;

struct Index {
  string name;
}

void create_index(string index_name, string table_name, string column_name) {
  writeln(index_name, " ", table_name, " ", column_name);
}

void drop_index(string index_name) {
  writeln(index_name);
}
