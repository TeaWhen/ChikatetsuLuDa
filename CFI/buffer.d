import std.stdio;
import std.string;
import std.file;

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
  f.write(content);
}