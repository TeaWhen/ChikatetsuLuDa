import std.string;
import std.conv;
import std.stdio;

struct Node {
  string val;
  Node[] children;
  bool is_leaf;
  ulong[] indexes;
}

//  0 for int
//  1 for char
//  2 for float

class BTree {
  Node root;
  int type;

  this (int type) {
    this.type = type;
    root.is_leaf = false;
  }

  ~this () {

  }

  void insert (string val, ulong index) {
    if (root.children.length == 0) {
      Node node;
      node.is_leaf = true;
      node.val = val;
      node.indexes ~= index;
      root.children ~= node;
    } else {
      _insert(val, index, root);
    }
  }

  void _insert (string val, ulong index, ref Node node) {
    ulong child_index;
    for (ulong left = 0, right = node.children.length - 1; left != right; ) {
      if (less(val, node.children[left].val)) {
        child_index = left;
        break;
      } else if (bigger(val, node.children[right].val)) {
        child_index = right;
        break;
      } else if (val == node.children[left].val) {
        child_index = left;
        break;
      } else if (val == node.children[right].val) {
        child_index = right;
        break;
      } else if (right - left == 1) {
        child_index = right;
        break;
      }
      ulong mid = (left + right) / 2;
      if (bigger(val, node.children[mid].val)) {
        left = mid;
      } else if (less(val, node.children[mid].val)) {
        right = mid;
      } else {
        left = right;
        child_index = mid;
      }
    }
    if (bigger(val, node.children[child_index].val)) {
      Node t;
      t.is_leaf = true;
      t.val = val;
      t.indexes ~= index;
      Node[] tt;
      tt ~= node.children[0..child_index+1];
      tt ~= t;
      tt ~= node.children[child_index+1..node.children.length];
      node.children = tt;
    } else if (less(val, node.children[child_index].val)) {
      Node t;
      t.is_leaf = true;
      t.val = val;
      t.indexes ~= index;
      Node[] tt;
      tt ~= node.children[0..child_index];
      tt ~= t;
      tt ~= node.children[child_index..node.children.length];
      node.children = tt;
    } else {
      node.children[child_index].indexes ~= index;
    }
    writeln(root);
  }

  void remove (string val, ulong index) {
    _remove(val, index, root);
  }

  void _remove (string val, ulong index, ref Node node) {
    writeln("_remove");
    ulong child_index;
    for (ulong left = 0, right = node.children.length - 1; left != right; ) {
      if (less(val, node.children[left].val)) {
        child_index = left;
        break;
      } else if (bigger(val, node.children[right].val)) {
        child_index = right;
        break;
      } else if (val == node.children[left].val) {
        child_index = left;
        break;
      } else if (val == node.children[right].val) {
        child_index = right;
        break;
      } else if (right - left == 1) {
        child_index = right;
        break;
      }
      ulong mid = (left + right) / 2;
      if (bigger(val, node.children[mid].val)) {
        left = mid;
      } else if (less(val, node.children[mid].val)) {
        right = mid;
      } else {
        left = right;
        child_index = mid;
      }
    }
    writeln(child_index);
    if (bigger(val, node.children[child_index].val)) {

    } else if (less(val, node.children[child_index].val)) {

    } else {
      writeln("inside");
      for (int i = 0; i < node.children[child_index].indexes.length; i++) {
        if (node.children[child_index].indexes[i] == index) {
          ulong[] indexes;
          indexes ~= node.children[child_index].indexes[0..i];
          indexes ~= node.children[child_index].indexes[i+1..node.children[child_index].indexes.length];
          node.children[child_index].indexes = indexes;
          break;
        }
      }
      if (node.children[child_index].indexes.length == 0) {
        Node[] t;
        t ~= node.children[0..child_index];
        t ~= node.children[child_index+1..node.children.length];
        node.children = t;
      }
    }
  }

  ulong[] find (string val) {
    ulong[] result = _find(val, root);
    return result;
  }

  ulong[] _find(string val, Node node) {
    ulong[] result;
    ulong child_index;
    for (ulong left = 0, right = node.children.length - 1; left != right; ) {
      if (less(val, node.children[left].val)) {
        child_index = left;
        break;
      } else if (bigger(val, node.children[right].val)) {
        child_index = right;
        break;
      } else if (val == node.children[left].val) {
        child_index = left;
        break;
      } else if (val == node.children[right].val) {
        child_index = right;
        break;
      } else if (right - left == 1) {
        child_index = right;
        break;
      }
      ulong mid = (left + right) / 2;
      if (bigger(val, node.children[mid].val)) {
        left = mid;
      } else if (less(val, node.children[mid].val)) {
        right = mid;
      } else {
        left = right;
        child_index = mid;
      }
    }
    writeln(child_index);
    if (bigger(val, node.children[child_index].val)) {

    } else if (less(val, node.children[child_index].val)) {

    } else {
      result ~= node.children[child_index].indexes;
      return result;
    }
    return result;
  }

  bool less (string val1, string val2) {
    switch (this.type) {
      case 0:
        int a = to!int(val1);
        int b = to!int(val2);
        if (a < b)
          return true;
        else
          return false;
      case 1:
        if (val1 < val2)
          return true;
        else
          return false;
      case 2:
        float a = to!float(val1);
        float b = to!float(val2);
        if (a < b)
          return true;
        else
          return false;
      default:
        return false;
    }
  }

  bool bigger (string val1, string val2) {
    switch (this.type) {
      case 0:
        int a = to!int(val1);
        int b = to!int(val2);
        if (a > b)
          return true;
        else
          return false;
      case 1:
        if (val1 > val2)
          return true;
        else
          return false;
      case 2:
        float a = to!float(val1);
        float b = to!float(val2);
        if (a > b)
          return true;
        else
          return false;
      default:
        return false;
    }
  }

  void print() {
    writeln(root);
    for (int i = 0; i < root.children.length; i++) {
      writeln(root.children[i]);
    }
  }

}