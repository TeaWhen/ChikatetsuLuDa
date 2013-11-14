import std.stdio;
import std.string;
import std.file;

import CFI.file;

const int BLOCK_SIZE = 8192;

File create_block(string filename) {
  return create_file(filename);
}