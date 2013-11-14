import std.stdio;
import std.string;
import std.file;
import std.conv;

import API.common;

const string BASE_PATH = "data";
const string META_FILE_NAME = "meta.ckt";
const string SCHEMA_EXTENSION = "schema";
const string RECORD_EXTENSION = "record";

File load_file(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  if (!exists(path)) {
    std.file.write(path, "");
  }
  return File(path, "r");
}

File create_file(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  return File(path, "w");
}

int delete_file(string filename) {
  _init();
  try {
    string path = format("%s/%s", BASE_PATH, filename);
    remove(path);
  } catch (FileException e) {
    return -1;
  }
  return 0;
}

File edit_file(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  if (!exists(path)) {
    std.file.write(path, "");
  }
  return File(path, "w+");
}

File append_file(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  if (!exists(path)) {
    std.file.write(path, "");
  }
  return File(path, "a+");
}

File load_file_binary(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  if (!exists(path)) {
    std.file.write(path, "");
  }
  return File(path, "rb");
}

File write_file_binary(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  if (!exists(path)) {
    std.file.write(path, "");
  }
  return File(path, "wb");
}

void _init() {
  if (!exists(BASE_PATH)) {
    mkdir(BASE_PATH);
  }
}

Block load_block(string table_name, ulong index) {
  if (tables[table_name].blocks.length <= index) {
    Block block;
    block.loaded = false;
    block.size = 10;
    tables[table_name].blocks ~= block;
  }
  if (tables[table_name].blocks[index].loaded) {
    return tables[table_name].blocks[index];
  }
  Block block;
  Table table = tables[table_name];
  string file_name = format("%s.%s", table_name, RECORD_EXTENSION);
  auto f = load_file_binary(file_name);
  f.seek(index * table.schema.size);
  // TODO save and load block length
  for (int i = 0; i < table.blocks[index].size; i++) {
    string[] values;
    foreach (col; table.schema.cols) {
      switch (col.type) {
        case ColType.CKint:
          int[] raw;
          raw.length = 1;
          f.rawRead(raw);
          writeln(raw);
          values ~= to!string(raw[0]);
          break;
        case ColType.CKfloat:
          float[] raw;
          raw.length = 1;
          f.rawRead(raw);
          writeln(raw);
          values ~= to!string(raw[0]);
          break;
        case ColType.CKchar:
          string[] raw;
          raw.length = col.size;
          f.rawRead(raw);
          writeln(raw);
          values ~= to!string(raw);
          break;
        default:
          writeln("error");
      }
    }
  }
  writeln(block);
  return block;
}

void write_block(string table_name, ulong index) {

}