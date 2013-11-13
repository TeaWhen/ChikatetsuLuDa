import std.string;
import std.conv;
import std.stdio;

struct Node {
  string val;
  Node[] children;
  bool is_leaf;
  ulong[] indexes;
}

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
    for (ulong i = node.children.length - 1; ; i--) {
      if (node.children[i].is_leaf) {
        if (node.children[i].val == val) {
          node.children[i].indexes ~= index;
          return;
        } else if (bigger(val, node.children[i].val) && i == node.children.length - 1) {
          Node n;
          n.is_leaf = true;
          n.val = val;
          n.indexes ~= index;
          node.children ~= n;
        } else if (bigger(val, node.children[i].val)) {
          Node n;
          n.is_leaf = true;
          n.val = val;
          n.indexes ~= index;
          Node[] t;
          t ~= node.children[0..i];
          t ~= n;
          t ~= node.children[i+1..node.children.length];
          node.children = t;
          return;
        }
      } else {
        // TODO deal with multilevel
        if (i == 0) {
          
        } else if (i == node.children.length - 1) {

        } else {

        }
      }
      if (i == 0) {
        break;
      }
    }
    Node n;
    n.is_leaf = true;
    n.val = val;
    n.indexes ~= index;
    Node[] t;
    t ~= n;
    t ~= node.children;
    node.children = t;
  }

  void remove (string val, ulong index) {

  }

  ulong[] find (string val) {
    ulong[] result = _find(val, root);
    return result;
  }

  ulong[] _find(string val, Node node) {
    ulong[] result;
    for (ulong i = 0; i < node.children.length; i++) {
      if (node.children[i].is_leaf) {
        if (node.children[i].val == val) {
          return node.children[i].indexes;
        } else if (less(val, node.children[i].val)) {
          writeln(val, node.children[i].val);
          return result;
        }
      } else {
        result ~= _find(val, node.children[i]);
      }
    }
    return result;
  }

  bool less (string val1, string val2) {
    switch (this.type) {
      case 0:
        int a = to!int(val1);
        int b = to!int(val2);
        return a < b;
      default:
        return false;
    }
  }

  bool bigger (string val1, string val2) {
    switch (this.type) {
      case 0:
        int a = to!int(val1);
        int b = to!int(val2);
        writeln(a);
        writeln(b);
        writeln(a > b);
        if (a > b)
          return true;
        else
          return false;
      default:
        return false;
    }
  }

  void print() {
    writeln(root.children.length);
    for (ulong i = 0; i < 100; i++) {
      writeln(root.children[i]);
    }
  }

}