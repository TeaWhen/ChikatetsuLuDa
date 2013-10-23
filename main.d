import std.stdio;

import CLI.interp;
import API.schema;

void main(string args[]) {
  writeln("Welcome to the Chikatetsu monitor. Command ends with “;”.");

  load_schema();
  handler();
}
