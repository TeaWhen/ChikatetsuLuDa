import std.string;

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

  void _insert (string val, ulong index, Node node) {
    if (node.val == val) {
      node.indexes ~= index;
    } else {
      Node n;
      n.is_leaf = true;
      n.val = val;
      n.indexes ~= index;
      node.children ~= n;
    }
  }

  void remove (string val, ulong index) {

  }

  ulong[] find (string val) {
    ulong[] result = _find(val, root);
    return result;
  }

  ulong[] _find(string val, Node node) {
    ulong[] result;
    for (int i = 0; i < node.children.length; i++) {
      if (node.children[i].is_leaf) {
        if (node.children[i].val == val) {
          return node.children[i].indexes;
        }
      } else {
        result ~= _find(val, node.children[i]);
      }
    }
    return result;
  }

  static int compare (string val1, string val2) {
    return 0;
  }
}