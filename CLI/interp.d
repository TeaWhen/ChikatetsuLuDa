import std.string;
import std.stdio;
import std.regex;
import std.conv;
import std.c.process;
import std.file;

import API.table;
import API.record;
import API.index;
import API.schema;
import API.common;

auto create_table_reg = regex(r"^create table ([a-z]+) \(([ a-z\(\)0-9,]+)\);$");
auto drop_table_reg = regex(r"^drop table ([a-z]+);$");
auto create_index_reg = regex(r"^create index ([a-z]+) on ([a-z]+) \( ([a-z]+) \);$");
auto drop_index_reg = regex(r"^drop index ([a-z]+);$");
auto select_reg = regex(r"^select \* from ([a-z]+);$");
auto insert_reg = regex(r"^insert into ([a-z]+) values;$");
auto delete_reg = regex(r"^delete from ([a-z]+);$");
auto quit_reg = regex(r"^(quit)|(exit);$");
auto execfile_reg = regex(r"^execfile ([a-zA-Z0-9./_]+);$");

auto column_reg = regex(r"([a-z]+) ([a-z]+)(?: \(([0-9]+)\))?( unique)?,",  "g");
auto primary_key_reg = regex(r"primary key \( ([a-z]+) \)");

void handler() {
	while (true) {
    write("chikatetsu> ");
		string input = get_input(stdin);
    _handler(input);
	}
}

string get_input(File f) {
  string input;
  foreach (line_raw; f.byLine()) {
    string line = to!string(strip(line_raw));
    if (line == "") {
      break;
    }
    if (input == "") {
      input = line;
    }
    else {
      if (line != ";") {
        input = format("%s %s", input, line);
      }
      else {
        input = format("%s%s", input, line);
      }
    }
    if (endsWith(input, ";")) {
      break;
    }
    // write("chikatetsu. ");
  }
  if (f.eof()) {
    input = "quit;";
  }
  return input;
}

void _handler(string input) {
    if (input == "") {
      return;
    }
    else if (match(input, create_table_reg)) {
      auto m = match(input, create_table_reg);
      string table_name = m.captures[1];
      string scheme = format("%s,", strip(m.captures[2]));

      writeln(scheme);

      Column[] cols;

      auto ms = match(scheme, column_reg);
      while (ms.empty() == false) {
        Column col;
        col.name = ms.captures[1];
        col.is_unique = false;
        col.size = 0;

        string type = ms.captures[2];
        if (type == "char") {
          col.type = CHAR;
          col.size = to!int(ms.captures[3]);
        }
        else if (type == "int") {
          col.type = INT;
        }
        else {
          // Do Something
        }

        if (ms.captures[4] == " unique") {
          col.is_unique = true;
        }
        
        ++cols.length;
        cols[cols.length - 1] = col;

        ms.popFront();
      }

      string primary_key_name = "";
      if (match(scheme, primary_key_reg)) {
        auto mpk = match(scheme, primary_key_reg);
        primary_key_name = mpk.captures[1];
      }

      int pk = -1;
      for (int i = 0; i < cols.length; i++) {
        Column col = cols[i];
        if (col.name == primary_key_name) {
          pk = i;
          break;
        }
      }

      if (table_name in tables) {
        writeln(table_name, " is already in the database.");
      }
      else {
        create_table(table_name, cols, pk);
      }
      return;
    }

    if (match(input, drop_table_reg)) {
      auto m = match(input, drop_table_reg);
      string table_name = m.captures[1];
      drop_table(table_name);
      return;
    }

    if (match(input, create_index_reg)) {
      auto m = match(input, create_index_reg);
      string index_name = m.captures[1];
      string table_name = m.captures[2];
      string column_name = m.captures[3];
      create_index(index_name, table_name, column_name);
      return;
    }

    if (match(input, drop_index_reg)) {
      auto m = match(input, drop_index_reg);
      string index_name = m.captures[1];
      drop_index(index_name);
      return;
    }

    if (match(input, select_reg)) {
      auto m = match(input, select_reg);
      string table_name = m.captures[1];
      select_record(table_name);
      return;
    }

    if (match(input, insert_reg)) {
      auto m = match(input, insert_reg);
      string table_name = m.captures[1];
      insert_record(table_name);
      return;
    }

    if (match(input, delete_reg)) {
      auto m = match(input, delete_reg);
      string table_name = m.captures[1];
      delete_record(table_name);
      return;
    }

    if (match(input, quit_reg)) {
      writeln("Bye.");
      exit(0);
    }

    if (match(input, execfile_reg)) {
      auto m = match(input, execfile_reg);
      string file_name = m.captures[1];
      execfile(file_name);
      return;
    }

    if (input) {
      writeln("something is wrong.");
    }
}

void execfile(string file_name) {
  if (exists(file_name)) {
    // TODO support many statments in a single file
    auto f = File(file_name, "r");
    string input = get_input(f);
    _handler(input);
  }
  else {
    writeln(file_name, " does not exists.");
  }
}
