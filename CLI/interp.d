import std.string;
import std.stdio;
import std.regex;
import std.conv;

import table;
import record;
import index;
import schema;

auto create_table_reg = regex(r"^create table ([a-z]+) \(([ a-z\(\)0-9,]+)\);$");
auto drop_table_reg = regex(r"^drop table ([a-z]+);$");
auto create_index_reg = regex(r"^create index ([a-z]+) on ([a-z]+) \( ([a-z]+) \);$");
auto drop_index_reg = regex(r"^drop index ([a-z]+);$");
auto select_reg = regex(r"^select \* from ([a-z]+);$");
auto insert_reg = regex(r"^insert into ([a-z]+) values;$");
auto delete_reg = regex(r"^delete from ([a-z]+);$");
auto quit_reg = regex(r"^quit;$");
auto execfile_reg = regex(r"^execfile ([a-zA-Z0-9._-]+);$");

auto column_reg = regex(r"([a-z]+) ([a-z]+),",  "g");

void handler() {
	while (true) {
    write("chikatetsu> ");
		string input;

    foreach (line_raw; stdin.byLine()) {
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

    if (input == "") {
      continue;
    }

    if (match(input, create_table_reg)) {
      auto m = match(input, create_table_reg);
      string table_name = m.captures[1];
      string scheme = format("%s,", strip(m.captures[2]));

      writeln(scheme);

      Column[] cols;
      int pk = 0;
      auto ms = match(scheme, column_reg);
      while (ms.empty() == false) {
        Column col;
        col.name = ms.captures[1];
        string type = ms.captures[2];
        if (type == "char") {
          col.type = CHAR;
        }
        else if (type == "int") {
          col.type = INT;
        }
        else {

        }
        col.size = 0;
        col.is_unique = false;

        ++cols.length;
        cols[cols.length - 1] = col;

        ms.popFront();
      }

      create_table(table_name, cols, pk);
      continue;
    }

    if (match(input, drop_table_reg)) {
      auto m = match(input, drop_table_reg);
      string table_name = m.captures[1];
      drop_table(table_name);
      continue;
    }

    if (match(input, create_index_reg)) {
      auto m = match(input, create_index_reg);
      string index_name = m.captures[1];
      string table_name = m.captures[2];
      string column_name = m.captures[3];
      create_index(index_name, table_name, column_name);
      continue;
    }

    if (match(input, drop_index_reg)) {
      auto m = match(input, drop_index_reg);
      string index_name = m.captures[1];
      drop_index(index_name);
      continue;
    }

    if (match(input, select_reg)) {
      auto m = match(input, select_reg);
      string table_name = m.captures[1];
      select_record(table_name);
      continue;
    }

    if (match(input, insert_reg)) {
      auto m = match(input, insert_reg);
      string table_name = m.captures[1];
      insert_record(table_name);
      continue;
    }

    if (match(input, delete_reg)) {
      auto m = match(input, delete_reg);
      string table_name = m.captures[1];
      delete_record(table_name);
      continue;
    }

    if (match(input, quit_reg)) {
      break;
    }

    if (match(input, execfile_reg)) {
      auto m = match(input, execfile_reg);
      string file_name = m.captures[1];
      execfile(file_name);
      continue;
    }

    if (input) {
      writeln("something is wrong.");
    }
	}
}

void execfile(string file_name) {
  writeln("loading file ", file_name);
}