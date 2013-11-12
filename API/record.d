import std.string;
import std.stdio;
import std.conv;

import API.common;
import CFI.buffer;

void insert_record(string table_name, string[] values) {
  if (table_name in tables) {
    // TODO: type checking...
    Record record;
    record.values = values;
    tables[table_name].records ~= record;

    string file_name = format("%s.%s", table_name, RECORD_EXTENSION);
    File f = append_file(file_name);
    for (int i = 0; i < values.length; i++) {
      f.writeln(values[i]);
    }
  }
  else {
    writeln(table_name, " doesn't exist.");
  }
}

void delete_record(string table_name) {
  writeln("deleting * from ", table_name);
}

Record[] select_record(string table_name, Predict[] predicts) {
  writeln("selecting * from ", table_name);
  Record[] records = tables[table_name].records;
  Record[] result;
  foreach (record; records) {
    bool vaild = true;
    foreach (predict; predicts) {
      switch (predict.op_type) {
        case PredictOPType.eq:
          if (record.values[predict.col_index] != predict.value) {
            vaild = false;
          }
          break;
        default:
          writeln("something is wrong.");
      }
    }
    if (vaild) {
      result ~= record;
    }
  }
  return result;
}

Record[] load_records(string table_name, Schema schema) {
  Record[] records;
  string file_name = format("%s.%s", table_name, RECORD_EXTENSION);
  auto f = load_file(file_name);
  int counter = 0;
  auto length = schema.cols.length;
  string[] values;
  foreach (line; f.byLine()) {
    counter++;
    values ~= to!string(strip(line));
    if (counter == length) {
      Record record;
      record.values = values;
      records ~= record;
      counter = 0;
      values.length = 0;
    }
  }
  return records;
}