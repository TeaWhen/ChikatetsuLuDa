import std.string;
import std.stdio;
import std.regex;
import std.conv;

import table;
import record;
import index;

auto create_table_reg = regex(r"^create table [a-zA-Z]+ \($");
auto drop_table_reg = regex(r"^drop table ([a-zA-Z]+);$");
auto create_index_reg = regex(r"^create index ([a-zA-Z]+) on ([a-zA-Z]+) \( ([a-zA-Z]+) \);$");
auto drop_index_reg = regex(r"^drop index ([a-zA-Z]+);$");
auto select_reg = regex(r"^select \* from ([a-zA-Z]+);$");
auto insert_reg = regex(r"^insert into ([a-zA-Z]+) values;$");
auto delete_reg = regex(r"^delete from ([a-zA-Z]+);$");
auto quit_reg = regex(r"^quit;$");
auto execfile_reg = regex(r"^execfile ([a-zA-Z0-9._-]+);$");

void handler() {
	while (true) {
    write("chikatetsu> ");
		string input;

    foreach (line_raw; stdin.byLine()) {
      string line = to!string(strip(line_raw));
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
      write("chikatetsu. ");
    }

    if (match(input, drop_table_reg)) {
      auto m = match(input, drop_table_reg);
      string table_name = m.captures[1];
      drop_table(table_name);
    }

    if (match(input, create_index_reg)) {
      auto m = match(input, create_index_reg);
      string index_name = m.captures[1];
      string table_name = m.captures[2];
      string column_name = m.captures[3];
      create_index(index_name, table_name, column_name);
    }

    if (match(input, drop_index_reg)) {
      auto m = match(input, drop_index_reg);
      string index_name = m.captures[1];
      drop_index(index_name);
    }

    if (match(input, select_reg)) {
      auto m = match(input, select_reg);
      string table_name = m.captures[1];
      select_record(table_name);
    }

    if (match(input, insert_reg)) {
      auto m = match(input, insert_reg);
      string table_name = m.captures[1];
      insert_record(table_name);
    }

    if (match(input, delete_reg)) {
      auto m = match(input, delete_reg);
      string table_name = m.captures[1];
      delete_record(table_name);
    }

    if (match(input, quit_reg)) {
      break;
    }

    if (match(input, execfile_reg)) {
      auto m = match(input, execfile_reg);
      string file_name = m.captures[1];
      execfile(file_name);
    }
	}
}

void execfile(string file_name) {
  writeln("loading file ", file_name);
}