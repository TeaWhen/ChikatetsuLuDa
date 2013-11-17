import std.string;
import std.stdio;
import std.conv;

import orange.serialization._;
import orange.serialization.archives._;

import API.common;
import CFI.file;

Schema load_schema(string name) {
  writeln("load_schema");
  Schema schema;
  string file_name = format("%s.%s", name, SCHEMA_EXTENSION);
  auto f = load_file(file_name);
  string val;
  while (!f.eof()) {
    val ~= f.readln();
  }
  auto archive = new XmlArchive!(char);
  auto serializer = new Serializer(archive);
  archive.beginUnarchiving(val);
  schema = serializer.deserialize!(Schema)(archive.untypedData);
  return schema;
}

void save_schema(string name, Schema schema) {
  writeln("save_schema");
  string file_name = format("%s.%s", name, SCHEMA_EXTENSION);
  auto f = create_file(file_name);
  auto archive = new XmlArchive!(char);
  auto serializer = new Serializer(archive);
  serializer.serialize(schema);
  f.writeln(to!string(archive.untypedData));
}

void drop_schema(string name) {
  string file_name = format("%s.%s", name, SCHEMA_EXTENSION);
  delete_file(file_name);
}
