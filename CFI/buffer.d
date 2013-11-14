import std.stdio;
import std.string;
import std.file;
import std.conv;

import CFI.file;

const int BLOCK_SIZE = 8192;

File create_block(string filename) {
  return create_file(filename);
}

void write_block(string table_name, uint block_id, string content) {
  writeln(table_name, block_id, content);

  string file_name = format("%s.%s", table_name, RECORD_EXTENSION);
  auto f = create_file(file_name);
  f.seek(block_id * BLOCK_SIZE);
  f.rawWrite(content);
  for (int i = 0; i < BLOCK_SIZE - content.length; i++) {
    f.rawWrite("|");
  }
}

ubyte[] load_block(string table_name, ulong block_id, ref bool eof) {
  writeln("load_block");
  ubyte[] ret;
  string file_name = format("%s.%s", table_name, RECORD_EXTENSION);
  auto f = load_file(file_name);
  writeln(f.size());
  if (f.size() <= block_id * BLOCK_SIZE) {
    eof = true;
    return ret[];
  } else {
    ret.length = BLOCK_SIZE;
  }
  f.seek(block_id * BLOCK_SIZE);
  f.rawRead(ret);
  writeln(ret);
  return ret[];
}