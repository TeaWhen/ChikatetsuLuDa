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

    bool is_inserted = false;
    ulong index = 0;
    foreach (ref block; tables[table_name].blocks){
      if (block.size < tables[table_name].block_size) {
        load_block(table_name, index);
        block.records ~= record;
        is_inserted = true;
        break;
      }
      index += 1;
    }
    if (!is_inserted) {
      Block block;
      block.records ~= record;
      block.size += 1;
      block.loaded = true;
      tables[table_name].blocks ~= block;
      writeln(block);
    }
  }
  else {
    writeln(table_name, " doesn't exist.");
  }
}

void delete_record(string table_name, Predict[] predicts) {
  if (table_name in tables) {
    foreach (ref block; tables[table_name].blocks) {
      Record[] result;
      foreach (record; block.records) {
        if (!validation(tables[table_name], record, predicts)) {
          result ~= record;
        }
      }
      block.records = result;
    }
  }
}

Record[] select_record(string table_name, Predict[] predicts) {
  ulong[] block_indexes = range(0, tables[table_name].blocks.length);
  Predict[] predicts_t;
  foreach (predict; predicts) {
    bool is_indexed = false;
    for (ulong i = 0; i < tables[table_name].indexes.length; i++) {
      if (tables[table_name].indexes[i].col_index == predict.col_index) {
        is_indexed = true;
        ulong[] indexes_raw = tables[table_name].indexes[i].btree.find(predict.value);
        ulong[] indexes_t;
        for (ulong j = 0; j < block_indexes.length; j++) {
          for (ulong k = 0; k < indexes_raw.length; k++) {
            if (block_indexes[j] == indexes_raw[k]) {
              indexes_t ~= block_indexes[j];
            }
          }
        }
        block_indexes = indexes_t;
      }
    }
    if (!is_indexed) {
      predicts_t ~= predict;
    }
  }

  Record[] records;
  for (int i = 0; i < block_indexes.length; i++) {
    records ~= tables[table_name].blocks[i].records;
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
  writeln("save_records");
  foreach (table; tables) {
    File f = write_file_binary(format("%s.%s", table.schema.name, RECORD_EXTENSION));
    foreach (block; table.blocks) {
      writeln(block);
      for (int i = 0; i < 128; i++) {
        Record record;
        // if (i >= block.size) {
          record = block.records[0];
        //} else {
        //  record = block.records[i];
        //}
        foreach (value; record.values) {
          foreach (ch; value) {
            char raw = to!char(ch);
            f.write(raw);
          }
        }
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
    values ~= to!(string)(strip(line));
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
        case PredictOPType.gt:
          if (table.schema.cols[predict.col_index].type == ColType.CKint) {
            if (to!int(record.values[predict.col_index]) <= to!int(predict.value)) {
              valid = false;
            }
          } else if (table.schema.cols[predict.col_index].type == ColType.CKfloat) {
            if (to!float(record.values[predict.col_index]) <= to!float(predict.value)) {
              valid = false;
            }
          } else {
            if (record.values[predict.col_index] <= predict.value) {
              valid = false;
            }
          }
          break;
        case PredictOPType.leq:
          if (table.schema.cols[predict.col_index].type == ColType.CKint) {
            if (to!int(record.values[predict.col_index]) > to!int(predict.value)) {
              valid = false;
            }
          } else if (table.schema.cols[predict.col_index].type == ColType.CKfloat) {
            if (to!float(record.values[predict.col_index]) > to!float(predict.value)) {
              valid = false;
            }
          } else {
            if (record.values[predict.col_index] > predict.value) {
              valid = false;
            }
          }
          break;
        case PredictOPType.geq:
          if (table.schema.cols[predict.col_index].type == ColType.CKint) {
            if (to!int(record.values[predict.col_index]) < to!int(predict.value)) {
              valid = false;
            }
          } else if (table.schema.cols[predict.col_index].type == ColType.CKfloat) {
            if (to!float(record.values[predict.col_index]) < to!float(predict.value)) {
              valid = false;
            }
          } else {
            if (record.values[predict.col_index] < predict.value) {
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