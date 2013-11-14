import std.string;
import std.stdio;
import std.conv;

import API.common;
import API.btree;
import CFI.buffer;
import CFI.file;

void create_index(string name, string table_name, string col_name) {
  Index index;
  index.name = name;
  index.table_name = table_name;
  for (uint i = 0; i < tables[table_name].schema.cols.length; i++) {
    if (col_name == tables[table_name].schema.cols[i].name) {
      index.col_index = i;
      break;
    }
  }
  int type = 0;
  switch (tables[table_name].schema.cols[index.col_index].type) {
    case ColType.CKint:
      type = 0;
      break;
    case ColType.CKchar:
      type = 1;
      break;
    case ColType.CKfloat:
      type = 2;
      break;
    default:
      type = 1;
  }
  BTree btree = new BTree(type);
  for (uint i = 0; i < tables[table_name].records.length; i++) {
    if (i % 100 == 0)
      writeln(i);
    btree.insert(tables[table_name].records[i].values[index.col_index], i);
  }
  btree.print();
  index.btree = btree;
  tables[table_name].indexes ~= index;

  string[] index_name_list = load_index_list(table_name);
  index_name_list ~= name;
  save_index_list(table_name, index_name_list);

  save_indexes(name, table_name);
}

void drop_index(string index_name) {
  string table_name;
  foreach (table; tables) {
    Index[] result_indexes;
    foreach (index; table.indexes) {
      if (index.name != index_name) {
        result_indexes ~= index;
      } else {
        table_name = table.schema.name;
      }
    }
    table.indexes = result_indexes;
  }

  string file_name = format("%s_%s.%s", table_name, index_name, INDEX_EXTENSION);
  delete_file(file_name);
}

void save_indexes(string name, string table_name) {
  string file_name = format("%s_%s.%s", table_name, name, INDEX_EXTENSION);
  auto f = create_file(file_name);
  foreach (index; tables[table_name].indexes) {
    if (index.name == name) {
      f.writeln(index.name);
      f.writeln(index.table_name);
      f.writeln(index.col_index);
      // Save Index
      f.writeln(index.btree.to_string());
      break;
    }
  }
}

Index[] load_indexes(string name, string table_name) {
  Index[] indexes;
  string file_name = format("%s_%s.%s", table_name, name, INDEX_EXTENSION);
  auto f = load_file(file_name);
  indexes = to!(Index[])(split(f.readln()));
  writeln(indexes);
  return indexes;
}

string[] load_index_list(string table_name) {
  string[] index_name_list;
  string file_name = format("%s.%s", table_name, INDEX_EXTENSION);
  auto f = load_file(file_name);
  foreach (line; f.byLine()) {
    writeln(line);
    index_name_list ~= to!string(strip(line));
  }
  return index_name_list;
}

void save_index_list(string table_name, string[] index_name_list) {
  string file_name = format("%s.%s", table_name, INDEX_EXTENSION);
  auto f = create_file(file_name);
  foreach (index_name; index_name_list) {
    f.writeln(index_name);
  }
}
