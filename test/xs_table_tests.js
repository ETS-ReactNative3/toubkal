// Generated by CoffeeScript 1.4.0
(function() {
  var Ordered_Set, Set, Table, XS, books, chai, columns, from_HTML_to_object, organizer;

  from_HTML_to_object = function(node) {
    var align, cell, columns, data, i, j, o, rows, v, _i, _j, _k, _len, _len1, _ref, _ref1, _ref2;
    rows = node.rows;
    columns = [];
    data = [];
    _ref = rows[0].cells;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cell = _ref[_i];
      columns.push({
        id: cell.getAttribute("column_id"),
        label: cell.innerHTML
      });
    }
    for (i = _j = 1, _ref1 = rows.length; 1 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 1 <= _ref1 ? ++_j : --_j) {
      j = 0;
      o = {};
      _ref2 = rows[i].cells;
      for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
        cell = _ref2[_k];
        v = cell.innerHTML;
        align = cell.style.textAlign;
        if (!isNaN(parseInt(v))) {
          v = parseInt(v);
          if (align !== "right") {
            columns[j].align = align;
          }
        } else {
          if (typeof align === "function" ? align(abd(align !== "left")) : void 0) {
            columns[j].align = align;
          }
        }
        o[columns[j].id] = v;
        j++;
      }
      data.push(o);
    }
    return {
      columns: columns,
      data: data
    };
  };

  XS = typeof require !== "undefined" && require !== null ? (require('../src/xs.js')).XS : this.XS;

  if (typeof require !== "undefined" && require !== null) {
    require('../src/code.js');
    require('../src/connection.js');
    require('../src/filter.js');
    require('../src/ordered_set.js');
    require('../src/aggregator.js');
    require('../src/table.js');
  }

  if (typeof require !== "undefined" && require !== null) {
    chai = require('chai');
  }

  if (chai != null) {
    chai.should();
  }

  Set = XS.Set;

  Table = XS.Table;

  Ordered_Set = XS.Ordered_Set;

  columns = new Set([
    {
      id: "id",
      label: "ID"
    }, {
      id: "title",
      label: "Title"
    }, {
      id: "author",
      label: "Author"
    }
  ], {
    name: "Columns Set"
  });

  organizer = new Set([
    {
      id: "title"
    }
  ], {
    name: "Organizer: by title ascending"
  });

  books = new Ordered_Set([
    {
      id: 1,
      title: "A Tale of Two Cities",
      author: "Charles Dickens",
      sales: 200,
      year: 1859,
      language: "English"
    }, {
      id: 2,
      title: "The Lord of the Rings",
      author: "J. R. R. Tolkien",
      sales: 150,
      year: 1955,
      language: "English"
    }, {
      id: 3,
      title: "Charlie and the Chocolate Factory",
      author: "Roald Dahl",
      sales: 13,
      language: "English"
    }, {
      id: 4,
      title: "The Da Vinci Code",
      author: "Dan Brown",
      sales: 80,
      year: 2003,
      language: "English"
    }
  ], organizer, {
    name: "Books"
  });

  books.table(document.getElementById("demo"), columns, organizer, {
    caption: "List of the best-selling books (source: wikipedia)"
  });

  describe('Columns_Set():', function() {
    it('columns should be equal to object.columns', function() {
      var object;
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return columns.get().should.be.eql(object.columns);
    });
    it('after add 2 objects: columns.add( objects ) should be equal to object.columns', function() {
      var object;
      columns.add([
        {
          id: "year",
          label: "Year",
          align: "center"
        }, {
          id: "language",
          label: "Language"
        }
      ]);
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return columns.get().should.be.eql(object.columns);
    });
    it('after columns.remove( object ), columns should be equal to object.columns', function() {
      var object;
      columns.remove([
        {
          id: "id",
          label: "ID"
        }
      ]);
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return columns.get().should.be.eql(object.columns);
    });
    return it('after columns.update( object ), columns should be equal to object.columns', function() {
      var object;
      columns.update([
        [
          {
            id: "language",
            label: "Language"
          }, {
            id: "sales",
            label: "Sales by millions of copies"
          }
        ]
      ]);
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return columns.get().should.be.eql(object.columns);
    });
  });

  describe('Table():', function() {
    it('books should be equal to object.data', function() {
      var object;
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return books.get().should.be.eql(object.data);
    });
    it('after books.add( objects ): books should be equal to object.data', function() {
      var object;
      books.add([
        {
          id: 5,
          title: "Angels and Demons",
          author: "Dan Brown",
          sales: 39,
          year: 2000,
          language: "English"
        }, {
          id: 6,
          title: "The Girl with the Dragon Tattoo",
          author: "Stieg Larsson",
          sales: 30,
          year: 2005,
          language: "Swedish"
        }, {
          id: 7,
          title: "The McGuffey Readers",
          author: "William Holmes McGuffey",
          sales: 125,
          year: 1853,
          language: "English"
        }, {
          id: 8,
          title: "The Hobbit",
          author: "J. R. R. Tolkien",
          sales: 100,
          year: 1937,
          language: "English"
        }, {
          id: 9,
          title: "The Hunger Games",
          author: "Suzanne Collins",
          sales: 23,
          year: 2008,
          language: "English"
        }, {
          id: 10,
          title: "Harry Potter and the Prisoner of Azkaban",
          author: "J.K. Rowling",
          sales: void 0,
          year: 1999,
          language: "English"
        }, {
          id: 11,
          title: "The Dukan Diet",
          author: "Pierre Dukan",
          sales: 10,
          year: 2000,
          language: "French"
        }, {
          id: 12,
          title: "Breaking Dawn",
          author: "Stephenie Meyer",
          sales: void 0,
          year: 2008,
          language: "English"
        }, {
          id: 13,
          title: "Lolita",
          author: "Vladimir Nabokov",
          sales: 50,
          year: 1955,
          language: "English"
        }, {
          id: 14,
          title: "And Then There Were None",
          author: "Agatha Christie",
          sales: 100,
          year: void 0,
          language: "English"
        }, {
          id: 15,
          title: "Steps to Christ",
          author: "Ellen G. White",
          sales: 60,
          year: null,
          language: "English"
        }
      ]);
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return books.get().should.be.eql(object.data);
    });
    it('after books.update( objects ): books should be equal to object.data', function() {
      var object;
      books.update([
        [
          {
            id: 2,
            title: "The Lord of the Rings",
            author: "J. R. R. Tolkien",
            year: 1955
          }, {
            id: 2,
            title: "The Lord of the Rings: The Fellowship of the Ring",
            author: "John Ronald Reuel Tolkien",
            year: 1955
          }
        ], [
          {
            id: 10,
            title: "Harry Potter and the Prisoner of Azkaban",
            author: "J.K. Rowling",
            year: 1999
          }, {
            id: 10,
            title: "Harry Potter and the Prisoner of Azkaban",
            author: "Joanne Rowling",
            year: 1999
          }
        ]
      ]);
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return books.get().should.be.eql(object.data);
    });
    return it('after books.remove( objects ): books should be equal to object.data', function() {
      var object;
      books.remove([
        {
          id: 1,
          title: "A Tale of Two Cities",
          author: "Charles Dickens",
          year: 1859
        }, {
          id: 13,
          title: "Lolita",
          author: "Vladimir Nabokov",
          year: 1955
        }, {
          id: 7,
          title: "The McGuffey Readers",
          author: "William Holmes McGuffey",
          year: 1853
        }
      ]);
      object = from_HTML_to_object(document.getElementsByTagName("table")[0]);
      return books.get().should.be.eql(object.data);
    });
  });

}).call(this);
