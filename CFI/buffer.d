import std.stdio;
import std.string;
import std.file;

<<<<<<< HEAD
const string BASE_PATH = "data";
const string META_FILE_NAME = "meta.ckt";
const string SCHEMA_EXTENSION = "schema";
const string RECORD_EXTENSION = "record";
const string INDEX_EXTENSION = "index";
=======
import CFI.file;
>>>>>>> 44d42b99458276aaab5010b3559ef5922ec2d45e

const int BLOCK_SIZE = 8192;

File create_block(string filename) {
  return create_file(filename);
}