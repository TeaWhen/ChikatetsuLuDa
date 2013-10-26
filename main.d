import std.stdio;
import std.string;
import std.conv;

import CLI.interp;
import API.schema;
import API.common;
import CFI.buffer;
import API.index;
import API.meta;

void main(string args[]) {
  writeln("Welcome to the Chikatetsu monitor. Command ends with “;”.");
  load_meta();
  load_tables();
  handler();
}
