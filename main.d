import std.stdio;
import std.string;
import std.conv;

import CLI.interp;
import API.schema;
import API.common;
import CFI.buffer;
import API.index;
import API.meta;
import API.btree;

void main(string args[]) {
  writeln("Welcome to the Chikatetsu monitor. Command ends with “;”.");
  load_meta();
  load_tables();
  handler();
}

void test_btree() {
  BTree btree = new BTree(0);
  btree.insert("123", 1320);
  btree.insert("123", 80);
  btree.insert("321", 1123);
  btree.insert("222", 7);
  btree.insert("92222", 7);
  btree.insert("222", 123);
  btree.insert("1", 123);
  btree.print();
  writeln(btree.find("222"));
  btree.remove("123", 80);
  btree.print();
}
