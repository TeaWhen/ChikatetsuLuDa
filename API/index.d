import std.string;
import std.stdio;

import API.common;

void create_index(string index_name, string table_name, string column_name) {
  writeln(index_name, " ", table_name, " ", column_name);
}

void drop_index(string index_name) {
  writeln(index_name);
}

Index[] load_indexes(string table_name) {
  Index[] indexes;
  return indexes;
}
