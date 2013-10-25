import std.stdio;

import CLI.interp;
import API.schema;
import API.common;

void main(string args[]) {
  writeln("Welcome to the Chikatetsu monitor. Command ends with “;”.");
  load_meta();
  load_tables();
  handler();
}

void load_meta() {

}

void load_tables() {
  
}
