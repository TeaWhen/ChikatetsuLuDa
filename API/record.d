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
  }
  else {
    writeln(table_name, " doesn't exist.");
  }
}

void delete_record(string table_name, Predict[] predicts) {
  if (table_name in tables) {
    Record[] result;
    foreach (record; tables[table_name].records) {
      if (!validation(tables[table_name], record, predicts)) {
        result ~= record;
      }
    }
    tables[table_name].records = result;
  }
}

Record[] select_record(string table_name, Predict[] predicts) {
  writeln("selecting * from ", table_name);

  ulong[] indexes = range(0, tables[table_name].records.length);
  Predict[] predicts_t;
  foreach (predict; predicts) {
    bool is_indexed = false;
    for (ulong i = 0; i < tables[table_name].indexes.length; i++) {
      if (tables[table_name].indexes[i].col_index == predict.col_index) {
        is_indexed = true;
        ulong[] indexes_raw = tables[table_name].indexes[i].btree.find(predict.value);
        ulong[] indexes_t;
        for (ulong j = 0; j < indexes.length; j++) {
          for (ulong k = 0; k < indexes_raw.length; k++) {
            if (indexes[j] == indexes_raw[k]) {
              indexes_t ~= indexes[j];
            }
          }
        }
        indexes = indexes_t;
      }
    }
    if (!is_indexed) {
      predicts_t ~= predict;
    }
  }

  Record[] records;
  for (int i = 0; i < indexes.length; i++) {
    records ~= tables[table_name].records[indexes[i]];
  }
  predicts = predicts_t;

  Record[] result;
  foreach (record; records) {
    if (validation(tables[table_name], record, predicts)) {
      result ~= record;
    }
  }
  return result;
}

void save_records() {
  foreach (table; tables) {
    File f = create_file(format("%s.%s", table.schema.name, RECORD_EXTENSION));
    foreach (record; table.records) {
      foreach (value; record.values) {
        f.writeln(value);
      }
    }
  }
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

ulong[] range(ulong start, ulong end) {
  ulong[] ret;
  for (ulong i = start; i < end; i++) {
    ret ~= i;
  }
  return ret;
}

bool validation(Table table, Record record, Predict[] predicts) {
  bool valid = true;
  foreach (predict; predicts) {
    if (valid) {
      switch (predict.op_type) {
        case PredictOPType.eq:
          if (record.values[predict.col_index] != predict.value) {
            valid = false;
          }
          break;
        case PredictOPType.neq:
          if (record.values[predict.col_index] == predict.value) {
            valid = false;
          }
          break;
        case PredictOPType.lt:
          if (table.schema.cols[predict.col_index].type == ColType.CKint) {
            if (to!int(record.values[predict.col_index]) >= to!int(predict.value)) {
              valid = false;
            }
          } else if (table.schema.cols[predict.col_index].type == ColType.CKfloat) {
            if (to!float(record.values[predict.col_index]) >= to!float(predict.value)) {
              valid = false;
            }
          } else {
            if (record.values[predict.col_index] >= predict.value) {
              valid = false;
            }
          }
          break;
        default:
          writeln("unknown error in API.record.validation !");
      }
    } else {
      break;
    }
  }
  return valid;
}