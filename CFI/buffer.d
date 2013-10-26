import std.stdio;
import std.string;
import std.file;

const string BASE_PATH = "data";
const string META_FILE_NAME = "meta.ckt";
const string SCHEMA_EXTENSION = "schema";

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

void _init() {
  if (!exists(BASE_PATH)) {
    mkdir(BASE_PATH);
  }
}