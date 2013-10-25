import std.stdio;
import std.string;
import std.file;

const string BASE_PATH = "data";
const string META_FILE_NAME = "meta.ckt";

File load_file(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  if (!exists(path)) {
    std.file.write(path, "");
  }
  return File(path, "r");
}

int create_file(string filename) {
  _init();
  string path = format("%s/%s", BASE_PATH, filename);
  std.file.write(path, "");
  return 0;
}

int delete_file(string filename) {
  _init();
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

void _init() {
  if (!exists(BASE_PATH)) {
    mkdir(BASE_PATH);
  }
}