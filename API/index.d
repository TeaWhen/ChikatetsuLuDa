import std.string;
import std.stdio;

import API.common;
import API.btree;

void create_index(string name, string table_name, string col_name) {
  Index index;
  index.name = name;
  index.table_name = table_name;
  for (ulong i = 0; i < tables[table_name].schema.cols.length; i++) {
    if (col_name == tables[table_name].schema.cols[i].name) {
      index.col_index = i;
      break;
    }
  }
  BTree btree = new BTree();
  for (ulong i = 0; i < tables[table_name].records.length; i++) {
    btree.insert(tables[table_name].records[i].values[index.col_index], i);
  }
  index.btree = btree;
}

void drop_index(string index_name) {
  writeln(index_name);
}

Index[] load_indexes(string table_name) {
  Index[] indexes;
  return indexes;
}
