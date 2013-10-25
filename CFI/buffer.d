import std.stdio;
import std.string;
import std.file;

const string BASE_PATH = "data";

File load_file(string filename) {
  if (!exists(BASE_PATH)) {
    mkdir(BASE_PATH);
  }
  string path = format("%s/%s", BASE_PATH, filename);
  if (!exists(path)) {
    std.file.write(path, "");
  }
  return File(path, "r");
}

int create_file(string filename) {
  return 0;
}

int delete_file(string filename) {
  return 0;
}