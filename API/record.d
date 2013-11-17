import std.string;
import std.stdio;
import std.conv;
import std.math;

import API.common;
import CFI.buffer;
import CFI.file;

void insert_record(string table_name, string[] values) {
  if (table_name in tables) {
    // TODO: type checking...
    Record record;
    record.values = values;
    record.deleted = false;
    tables[table_name].records ~= record;
  }
  else {
    writeln(table_name, " doesn't exist.");
  }
}

void delete_record(string table_name, Predict[] predicts) {
  if (table_name in tables) {
    Record[] result;
    int counter = 0;
    foreach (record; tables[table_name].records) {
      if (!validation(tables[table_name], record, predicts)) {
        // result ~= record;
      } else {
        tables[table_name].records[counter].deleted = true;
        foreach (index; tables[table_name].indexes) {
          if (index.col_index == predicts[0].col_index) {
            index.btree.remove(record.values[index.col_index], counter);
          }
        }
      }
      counter += 1;
    }
    // tables[table_name].records = result;
  }
}

Record[] select_record(string table_name, Predict[] predicts) {
  writeln("selecting * from ", table_name);

  uint[] indexes = range(0, tables[table_name].records.length);
  Predict[] predicts_t;
  foreach (predict; predicts) {
    bool is_indexed = false;
    for (uint i = 0; i < tables[table_name].indexes.length; i++) {
      if (tables[table_name].indexes[i].col_index == predict.col_index) {
        is_indexed = true;
        uint[] indexes_raw = tables[table_name].indexes[i].btree.find(predict.value);
        uint[] indexes_t;
        for (uint j = 0; j < indexes.length; j++) {
          for (uint k = 0; k < indexes_raw.length; k++) {
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
  writeln("save_records");
  foreach (table; tables) {
    uint num_records_in_block = BLOCK_SIZE / table.schema.size;
    uint num_blocks = cast(uint)ceil(cast(real)table.records.length / num_records_in_block);

    for (uint block_i = 0; block_i < num_blocks; ++block_i) {
      string content;
      for (uint record_i = 0; record_i < num_records_in_block; ++record_i) {
        uint record_id = block_i * num_records_in_block + record_i;
        if (record_id >= table.records.length) {
          break;
        }
        uint counter = 0;
        foreach (value; table.records[record_id].values) {
          writeln(value);
          switch (table.schema.cols[counter].type) {
            case ColType.CKint:
              writeln("int");
              int t1 = to!int(value) / 255 / 255 / 255;
              content ~= to!char(t1);
              int t2 = (to!int(value) - t1 * 255 * 255 * 255) / 255 / 255;
              content ~= to!char(t2);
              int t3 = (to!int(value) - t1 * 255 * 255 * 255 - t2 * 255 * 255) / 255;
              content ~= to!char(t3);
              content ~= to!char(to!int(value) % 255);
              break;
            case ColType.CKchar:
              writeln("char");
              content ~= value;
              for (int t = 0; t < table.schema.cols[counter].size - value.length; t++) {
                content ~= '|';
              }
              break;
            case ColType.CKfloat:
              writeln("float");
              content ~= to!char(to!float(value));
              break;
            default:
              assert(0);
          }
          counter += 1;
        }
      }
      write_block(table.schema.name, block_i, content);
    }
  }
}

void load_records(string table_name, Schema schema, ref Table table) {
  writeln("load_records");

  uint num_records_in_block = BLOCK_SIZE / table.schema.size;

  uint block = 0;
  bool eof = false;
  ubyte[] content = load_block(table.schema.name, block, eof);
  if (eof) {
    return;
  }
  while (content.length == BLOCK_SIZE) {
    uint current = 0;
    for (uint record_i = 0; record_i < num_records_in_block; ++record_i) {
      uint record_id = block * num_records_in_block + record_i;
      while (record_id < table.records.length) {
        Record record;
        table.records ~= record;
      }

      string[] values;
      for (uint counter = 0; counter < table.schema.cols.length; counter++) {
        writeln(counter);
        switch (table.schema.cols[counter].type) {
          case ColType.CKint:
            writeln("int");
            if (content[current] == 124) {
              return;
            }
            string val = to!string(to!int(content[current]) * 255 * 255 * 255 + to!int(content[current + 1]) * 255 * 255 + to!int(content[current + 2]) * 255 + to!int(content[current + 3]));
            current += 4;
            values ~= val;
            break;
          case ColType.CKchar:
            writeln("char");
            string value;
            for (int i = 0; i < table.schema.cols[counter].size; i++) {
              string val = to!string(to!char(content[current+i]));
              writeln(val);
              if (val == "|")
                break;
              value ~= val;
            }
            if (value.length == 0) {
              return;
            }
            current += table.schema.cols[counter].size;
            values ~= value;
            break;
          case ColType.CKfloat:
            writeln("float");
            // TODO
            break;
          default:
            assert(0);
        }
      }
      writeln(values);

      Record record;
      record.values = values;
      table.records ~= record;
    }

    block += 1;
    content = load_block(table.schema.name, block, eof);
    if (eof) {
      break;
    }
  }
}

uint[] range(uint start, uint end) {
  uint[] ret;
  for (uint i = start; i < end; i++) {
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