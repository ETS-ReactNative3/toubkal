###
    join.coffee
    
    Copyright (C) 2013-2015, Reactive Sets
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

###

# ----------------------------------------------------------------------------------------------
# test utils
# ----------

utils  = require( './tests_utils.js' ) unless this.expect

expect = this.expect || utils.expect
check  = this.check  || utils.check
rs     = this.rs     || utils.rs

RS           = rs.RS
extend       = RS.extend
value_equals = RS.value_equals
log          = RS.log.bind null, 'join tests'

compare_expected_values = ( expected, values ) ->
  # log 'compare_expected_values() expected: ', expected
  # log 'compare_expected_values() values:', values
  
  expect( values.length ).to.be expected.length
  
  for v in values
    # log 'value:', v
    
    expect( expected.filter( value_equals.bind this, v ).length ).to.be 1
  
# ----------------------------------------------------------------------------------------------
# join test suite
# ---------------

describe 'join() invalid parameter(s)', ->
  merge = ->
  
  it 'should throw if merge is not a function', ->
    f = -> rs.set().join rs.set(), [ 'id' ]
    
    expect( f ).to.throwException()
  
  it 'should throw if conditions is not an Array', ->
    f = -> rs.set().join rs.set(), {}, merge
    
    expect( f ).to.throwException()
  
  it 'should throw if conditions is empty', ->
    f = -> rs.set().join rs.set(), [], merge
    
    expect( f ).to.throwException()
  
  it 'should throw if condition is not a string or object', ->
    f = -> rs.set().join rs.set(), [ 1 ], merge
    
    expect( f ).to.throwException()
    
  it 'should throw if condition is an Array which first element is not a string', ->
    f = -> rs.set().join rs.set(), [ [ 1, 'id' ] ], merge
    
    expect( f ).to.throwException()

  it 'should throw if condition is an Array which second element is not a string', ->
    f = -> rs.set().join rs.set(), [ [ 'id', 1 ] ], merge
    
    expect( f ).to.throwException()

  it 'should throw if condition is an Array with less than two elements', ->
    f = -> rs.set().join rs.set(), [ [ 'id' ] ], merge
    
    expect( f ).to.throwException()

describe 'join() authors and books', ->
  authors = rs.set [
    { id:  1, name: "Charles Dickens"         }
    { id:  2, name: "J. R. R. Tolkien"        }
    #{ id:  3, name: "Dan Brown"               }
    { id:  4, name: "Paulo Coelho"            }
    { id:  5, name: "Stieg Larsson"           }
    { id:  6, name: "William Holmes McGuffey" }
    # { id:  7, name: "Suzanne Collins"         }
    { id:  8, name: "J.K. Rowling"            }
    { id:  9, name: "Pierre Dukan"            }
    { id: 10, name: "Stephenie Meyer"         }
    { id: 11, name: "Vladimir Nabokov"        }
    { id: 12, name: "Agatha Christie"         }
    # { id: 13, name: "Ellen G. White"          }
    # { id: 14, name: "Roald Dahl"              }
  ], { name: 'authors' }
  
  books = rs.set [
    { id:  1, title: "A Tale of Two Cities"                    , author_id:  1 }
    #{ id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
    { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
    { id:  4, title: "The Alchemist"                           , author_id:  4 }
    { id:  5, title: "Angels and Demons"                       , author_id:  3 }
    { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5 }
    # { id:  7, title: "The McGuffey Readers"                    , author_id:  6 }
    { id:  8, title: "The Hobbit"                              , author_id:  2 }
    { id:  9, title: "The Hunger Games"                        , author_id:  7 }
    { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8 }
    # { id: 11, title: "The Dukan Diet"                          , author_id:  9 }
    { id: 12, title: "Breaking Dawn"                           , author_id: 10 }
    # { id: 13, title: "Lolita"                                  , author_id: 11 }
    { id: 14, title: "And Then There Were None"                , author_id: 12 }
    # { id: 15, title: "Steps to Christ"                         , author_id: 13 }
    { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14 }
  ], { name: 'books' }
  
  merge_book_author = ( book, author ) ->
    if ( author and book )
      extend {}, book, { author_name: author.name }
    else
      book or { author_id: author.id, author_name: author.name }
  
  merge_author_book = ( author, book ) ->
    return merge_book_author( book, author )
  
  books_authors          = null
  books_authors_set      = null
  books_with_authors     = null
  books_with_authors_set = null
  authors_on_books       = null
  authors_on_books_set   = null
  books_or_authors       = null
  books_or_authors_set   = null
  
  expected_inner = [
    { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
    { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
    { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
    { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
    { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
    { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
    { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
  ]
  
  expected = [
    { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
    { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
    { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
    { id:  5, title: "Angels and Demons"                       , author_id:  3 }
    { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
    { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
    { id:  9, title: "The Hunger Games"                        , author_id:  7 }
    { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
    { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
    { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
    { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14 }
  ]
  
  expected_outer = [
    { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
    { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
    { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
    { id:  5, title: "Angels and Demons"                       , author_id:  3 }
    { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
    { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
    {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
    { id:  9, title: "The Hunger Games"                        , author_id:  7 }
    { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
    {                                                            author_id:  9, author_name: "Pierre Dukan"            }
    { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
    {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
    { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
    { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14 }
  ]
  
  describe 'joining books and authors sets', ->
    it 'should join books authors (inner join)', ( done ) ->
      # inner join
      books_authors = books.join(
        authors
        
        [ [ 'author_id', 'id' ] ]
        
        merge_book_author
        
        { key: [ 'id', 'author_id' ], name: 'books_authors' }
      )
      
      books_authors_set = books_authors.set()
      
      # left join
      books_with_authors = books.join(
        authors
        
        [ [ 'author_id', 'id' ] ]
        
        merge_book_author
        
        { key: [ 'id', 'author_id' ], left: true, name: 'books_with_authors' }
      )
      
      books_with_authors_set = books_with_authors.set()
      
      # right join
      authors_on_books = authors.join(
        books
        
        [ [ 'id', 'author_id' ] ]
        
        merge_author_book
        
        { key: [ 'id', 'author_id' ], right: true, name: 'authors_on_books' }
        
      ) #.trace 'authors_on_books trace'
      
      authors_on_books_set = authors_on_books.set()
      
      # full outer join
      books_or_authors = books.join(
        authors
        
        [ [ 'author_id', 'id' ] ]
        
        merge_book_author
        
        { key: [ 'id', 'author_id' ], outer: true, name: 'books_or_authors' }
        
      )#.trace 'authors_or_books trace'
      
      books_or_authors_set = books_or_authors.set()
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should join books authors (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should join books and authors (left join)', ( done ) ->
      books_with_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should join books and authors (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should join authors on books (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should join authors on books (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should join authors or books (full outer join)', ( done ) ->
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should join authors or books (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'adding two authors', ->
    it 'should allow to add one book which author was missing (inner join)', ( done ) ->
      authors._add [
        { id: 13, name: "Ellen G. White"          }
        { id: 14, name: "Roald Dahl"              }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                                    (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should allow to add an author to a book already present without its author (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                                                         (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                                                         (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                                                         (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should allow add an author to a book and add an author with no book (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        {                                                          , author_id: 13, author_name: "Ellen G. White"          }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                                                  (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'adding a book', ->
    it 'should add a book with its author (inner join)', ( done ) ->
      books._add [
        { id: 15, title: "Steps to Christ"                         , author_id: 13 }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should add a book with its author (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should add a book to an existing author (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                      (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'adding a book for an author who already has another book listed', ->
    it 'should add an additional book for its author (inner join)', ( done ) ->
      books._add [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                           (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                           (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                           (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                           (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                           (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                           (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                           (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'adding an author of two books already listed', ->
    it 'should add two books of that author (inner join)', ( done ) ->
      authors._add [
        { id:  3, name: "Dan Brown"               }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                  (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should add the author name of two books (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                      (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                      (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                      (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                      (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                      (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'removing an author of two books already listed', ->
    it 'should remove two books of that author (inner join)', ( done ) ->
      authors._remove [
        { id:  3, name: "Dan Brown"               }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                  (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should remove the author name of two books (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                         (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                         (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                         (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                         (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                         (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
  
  describe 'removing a book for an author who has another book listed', ->
    it 'should remove only this book (inner join)', ( done ) ->
      books._remove [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same           (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same           (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same           (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same           (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same           (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same           (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        { id: 15, title: "Steps to Christ"                         , author_id: 13, author_name: "Ellen G. White"          }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same           (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
  
  describe 'removing another book for an author with a single book', ->
    it 'should remove only this book (inner join)', ( done ) ->
      books._remove [
        { id: 15, title: "Steps to Christ"                         , author_id: 13 }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same           (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same           (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same           (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same           (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same           (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should remove the book but add back its author (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14, author_name: "Roald Dahl"              }
        {                                                          , author_id: 13, author_name: "Ellen G. White"          }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                             (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'removing two authors', ->
    it 'should remove one book with its author (inner join)', ( done ) ->
      authors._remove [
        { id: 13, name: "Ellen G. White"          }
        { id: 14, name: "Roald Dahl"              }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                     (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should remove one book with author adding back the book without the author (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14 }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                                                         (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                                                         (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                                                         (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                                                         (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5, author_name: "Stieg Larsson"           }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        { id: 14, title: "And Then There Were None"                , author_id: 12, author_name: "Agatha Christie"         }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14 }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                                                         (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'removing 6 books', ->
    it 'should remove 3 books with author (inner join)', ( done ) ->
      books._remove [
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  8, title: "The Hobbit"                              , author_id:  2 }
        { id:  6, title: "The Girl with the Dragon Tattoo"         , author_id:  5 }
        { id: 14, title: "And Then There Were None"                , author_id: 12 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id: 16, title: "Charlie and the Chocolate Factory"       , author_id: 14 }
      ]
      
      expected_inner = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should remove 6 books (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same    (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same    (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same    (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same    (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1, author_name: "Charles Dickens"         }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8, author_name: "J.K. Rowling"            }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10, author_name: "Stephenie Meyer"         }
        {                                                            author_id:  6, author_name: "William Holmes McGuffey" }
        {                                                            author_id:  9, author_name: "Pierre Dukan"            }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
        {                                                            author_id:  2, author_name: "J. R. R. Tolkien"        }
        {                                                            author_id:  5, author_name: "Stieg Larsson"           }
        {                                                            author_id: 12, author_name: "Agatha Christie"         }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same    (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'removing 7 authors', ->
    it 'should remove 3 books with author (inner join)', ( done ) ->
      authors._remove [
        { id:  1, name: "Charles Dickens"         }
        { id:  5, name: "Stieg Larsson"           }
        { id:  6, name: "William Holmes McGuffey" }
        { id:  8, name: "J.K. Rowling"            }
        { id:  9, name: "Pierre Dukan"            }
        { id: 10, name: "Stephenie Meyer"         }
        { id: 12, name: "Agatha Christie"         }
      ]
      
      expected_inner = [
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should remove 3 authors from books (left join)', ( done ) ->
      expected = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8 }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10 }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                 (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                 (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                 (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should remove 3 authors from books and 4 authors without books (full outer join)', ( done ) ->
      expected_outer = [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1 }
        { id:  4, title: "The Alchemist"                           , author_id:  4, author_name: "Paulo Coelho"            }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8 }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10 }
        {                                                            author_id: 11, author_name: "Vladimir Nabokov"        }
        {                                                            author_id:  2, author_name: "J. R. R. Tolkien"        }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                                             (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'removing all (5) remaining books then all (3) remaining authors', ->
    it 'should remove the last book (inner join)', ( done ) ->
      books._remove [
        { id:  1, title: "A Tale of Two Cities"                    , author_id:  1 }
        { id:  4, title: "The Alchemist"                           , author_id:  4 }
        { id:  9, title: "The Hunger Games"                        , author_id:  7 }
        { id: 10, title: "Harry Potter and the Prisoner of Azkaban", author_id:  8 }
        { id: 12, title: "Breaking Dawn"                           , author_id: 10 }
      ]
      
      authors._remove [
        { id:  2, name: "J. R. R. Tolkien"        }
        { id:  4, name: "Paulo Coelho"            }
        { id: 11, name: "Vladimir Nabokov"        }
      ]
      
      expected_inner = []
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same          (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should remove 5 remaining books (left join)', ( done ) ->
      expected = []
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same              (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same              (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same              (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should remove all remaining books and authors (full outer join)', ( done ) ->
      expected_outer = []
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                            (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'adding back 4 books then the 2 authors of these four books (2 books per author)', ->
    it 'should add 4 books with their 2 authors (inner join)', ( done ) ->
      books._add [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  8, title: "The Hobbit"                              , author_id:  2 }
      ]
      
      authors._add [
        { id:  2, name: "J. R. R. Tolkien"        }
        { id:  3, name: "Dan Brown"               }
      ]
      
      expected_inner = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                      (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same                      (left join)', ( done ) ->
      expected = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                      (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                      (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                      (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                      (full outer join)', ( done ) ->
      expected_outer = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                      (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'removing these 2 authors of those four books (2 books per author)', ->
    it 'should remove all 4 books (inner join)', ( done ) ->
      authors._remove [
        { id:  2, name: "J. R. R. Tolkien"        }
        { id:  3, name: "Dan Brown"               }
      ]
      
      expected_inner = []
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same        (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should remove 2 authors 4 from books (left join)', ( done ) ->
      expected = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
        { id:  8, title: "The Hobbit"                              , author_id:  2 }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                   (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same                   (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                   (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same                   (full outer join)', ( done ) ->
      expected_outer = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
        { id:  8, title: "The Hobbit"                              , author_id:  2 }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                   (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'removing last four books and adding back their 2 authors (2 books per author)', ->
    it 'should still show no books (inner join)', ( done ) ->
      books._remove [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
        { id:  8, title: "The Hobbit"                              , author_id:  2 }
      ]
      
      authors._add [
        { id:  2, name: "J. R. R. Tolkien"        }
        { id:  3, name: "Dan Brown"               }
      ]
      
      expected_inner = []
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same         (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should remove 4 books (left join)', ( done ) ->
      expected = []
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same    (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same    (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same    (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should remove 4 books and add back two authors (full outer join)', ( done ) ->
      expected_outer = [
        {                                                            author_id:  2, author_name: "J. R. R. Tolkien"        }
        {                                                            author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                             (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
  describe 'adding back two books of one authors (2 books per author)', ->
    it 'should add back these 2 books (inner join)', ( done ) ->
      books._add [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2 }
        { id:  8, title: "The Hobbit"                              , author_id:  2 }
      ]
      
      expected_inner = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same            (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same            (left join)', ( done ) ->
      expected = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same            (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same            (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same            (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should remove the one standalone author then add 2 books back of this author (full outer join)', ( done ) ->
      expected_outer = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        {                                                            author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                                                           (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
  
  describe 'adding back the two books of the second author (2 books per author)', ->
    it 'should add back these 2 books (inner join)', ( done ) ->
      books._add [
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
      ]
      
      expected_inner = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same            (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same            (left join)', ( done ) ->
      expected = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same            (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same            (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same            (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should remove one standalone author then add 2 books back of this author (full outer join)', ( done ) ->
      expected_outer = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3, author_name: "Dan Brown"               }
        { id:  5, title: "Angels and Demons"                       , author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                                                       (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
  
  describe 'removing these two books of the second author (2 books per author)', ->
    it 'should remove these 2 books (inner join)', ( done ) ->
      books._remove [
        { id:  3, title: "The Da Vinci Code"                       , author_id:  3 }
        { id:  5, title: "Angels and Demons"                       , author_id:  3 }
      ]
      
      expected_inner = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
      ]
      
      books_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same          (inner join) on donwstream set', ( done ) ->
      books_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_inner, values
    
    it 'should do the same          (left join)', ( done ) ->
      expected = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
      ]
      
      books_with_authors._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same          (left join) on downstream set', ( done ) ->
      books_with_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same          (right join)', ( done ) ->
      authors_on_books._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should do the same          (right join) on downstream set', ( done ) ->
      authors_on_books_set._fetch_all ( values ) -> check done, () ->
        compare_expected_values expected, values
    
    it 'should remove two books and add back one standalone author (full outer join)', ( done ) ->
      expected_outer = [
        { id:  2, title: "The Lord of the Rings"                   , author_id:  2, author_name: "J. R. R. Tolkien"        }
        { id:  8, title: "The Hobbit"                              , author_id:  2, author_name: "J. R. R. Tolkien"        }
        {                                                            author_id:  3, author_name: "Dan Brown"               }
      ]
      
      books_or_authors._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
    
    it 'should do the same                                         (full outer join) on downstream set', ( done ) ->
      books_or_authors_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_outer, values
  
  describe 'checking anti-state of downstream sets are empty', ->
    it 'should have nothing in (inner join)      downstream set anti-state', () ->
      expect( books_authors_set.b.length ).to.be 0
    
    it 'should have nothing in (left join)       downstream set anti-state', () ->
      expect( books_with_authors_set.b.length ).to.be 0
    
    it 'should have nothing in (right join)      downstream set anti-state', () ->
      expect( authors_on_books_set.b.length ).to.be 0
    
    it 'should have nothing in (full outer join) downstream set anti-state', () ->
      expect( books_or_authors_set.b.length ).to.be 0

describe 'join() users and users profile, on "id" attribute', ->
  users              = null
  profiles           = null
  merge_user_profile = null
  users_profiles     = null
  users_profiles_set = null
  expected           = null
  on_add             = null
  on_remove          = null
  on_update          = null
  
  describe 'joining users and users profile', ->
    it 'should have one user with no name', ( done ) ->
      users = rs.set [
        { id: 1, email: 'one@example.com' }
      ]
      
      profiles = rs.set [
        { id: 1, name: 'one' }
      ]
      
      merge_user_profile = ( user, profile ) -> extend {}, user, profile
      
      users_profiles = users.join(
          profiles,
          
          [ 'id' ],
          
          merge_user_profile,
          
          { left: true }
          
        ).trace 'users profiles trace' # Note: cannot put _on() on union output of join(), trace() or other pipelet is required for that
      
      users_profiles_set = users_profiles.set()
      
      users_profiles._on 'add',    ( values, options ) -> on_add    && on_add    values, options
      users_profiles._on 'remove', ( values, options ) -> on_remove && on_remove values, options
      users_profiles._on 'update', ( values, options ) -> on_update && on_update values, options
      
      expected = [
        { id: 1, email: 'one@example.com', name: 'one' }
      ]
      
      users_profiles._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should have one user with no name on downstream set', ( done ) ->
      users_profiles_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
  
  describe 'adding a user', ->
    it 'should add a user with no name', ( done ) ->
      on_add = ( values, options )  -> check done, ->
        expect( values ).to.be.eql [ { id: 2, email: 'two@example.com' } ]
        on_add = null
      
      users._add [ { id: 2, email: 'two@example.com' } ]
      
      expected.push { id: 2, email: 'two@example.com' }
    
    it 'should now have two users, one with no name', ( done ) ->
      users_profiles._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should now have two users, one with no name on downstream set', ( done ) ->
      users_profiles_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
  
  describe 'adding a user profile for second user', ->
    it 'should update second user to add name', ( done ) ->
      on_update = ( updates, options )  -> check done, ->
        expect( updates ).to.be.eql [
          [
            { id: 2, email: 'two@example.com' }
            { id: 2, email: 'two@example.com', name: 'two' }
          ]
        ]
        
        on_update = null
      
      profiles._add [ { id: 2, name: 'two' } ]
      
      expected[ 1 ] = { id: 2, email: 'two@example.com', name: 'two' }
      
    it 'should now have two users with names', ( done ) ->
      users_profiles._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should now have two users with names on downstream set', ( done ) ->
      users_profiles_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
  
  describe 'remove user profiles of both users', ->
    it 'should update first user to remove name', ( done ) ->
      on_update = ( updates, options )  -> check done, ->
        expect( updates ).to.be.eql [
          [
            { id: 1, email: 'one@example.com', name: 'one' }
            { id: 1, email: 'one@example.com' }
          ]
          [
            { id: 2, email: 'two@example.com', name: 'two' }
            { id: 2, email: 'two@example.com' }
          ]
        ]
        
        on_update = null
      
      profiles._remove [ { id: 1, name: 'one' }, { id: 2, name: 'two' } ]
      
      expected[ 0 ] = { id: 1, email: 'one@example.com' }
      expected[ 1 ] = { id: 2, email: 'two@example.com' }
      
    it 'should now have two users with no name', ( done ) ->
      users_profiles._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should now have two users with no name on downstream set', ( done ) ->
      users_profiles_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
  
  describe 'adding back both user profiles of both users', ->
    it 'should update first user to remove name', ( done ) ->
      on_update = ( updates, options )  -> check done, ->
        expect( updates ).to.be.eql [
          [
            { id: 1, email: 'one@example.com' }
            { id: 1, email: 'one@example.com', name: 'one' }
          ]
          [
            { id: 2, email: 'two@example.com' }
            { id: 2, email: 'two@example.com', name: 'two' }
          ]
        ]
        
        on_update = null
      
      profiles._add [ { id: 1, name: 'one' }, { id: 2, name: 'two' } ]
      
      expected[ 0 ] = { id: 1, email: 'one@example.com', name: 'one' }
      expected[ 1 ] = { id: 2, email: 'two@example.com', name: 'two' }
      
    it 'should now have two users with names', ( done ) ->
      users_profiles._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should now have two users with names on downstream set', ( done ) ->
      users_profiles_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
  
  describe 'removing both users', ->
    it 'remove both users', ( done ) ->
      on_remove = ( values, options )  -> check done, ->
        expect( values ).to.be.eql [
          { id: 1, email: 'one@example.com', name: 'one' }
          { id: 2, email: 'two@example.com', name: 'two' }
        ]
        
        on_remove = null
      
      users._remove [
        { id: 1, email: 'one@example.com' }
        { id: 2, email: 'two@example.com' }
      ]
      
      expected = []
      
    it 'should now have no user', ( done ) ->
      users_profiles._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should now have no user on downstream set', ( done ) ->
      users_profiles_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
  
  describe 'adding back both users', ->
    it 'add back both users', ( done ) ->
      on_add = ( values, options )  -> check done, ->
        expect( values ).to.be.eql [
          { id: 1, email: 'one@example.com', name: 'one' }
          { id: 2, email: 'two@example.com', name: 'two' }
        ]
        
        on_add = null
      
      users._add [
        { id: 1, email: 'one@example.com' }
        { id: 2, email: 'two@example.com' }
      ]
      
      expected = [
        { id: 1, email: 'one@example.com', name: 'one' }
        { id: 2, email: 'two@example.com', name: 'two' }
      ]
      
    it 'should now have two users with names', ( done ) ->
      users_profiles._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should now have two users with names on downstream set', ( done ) ->
      users_profiles_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should have nothing in downstream set anti-state', () ->
      expect( users_profiles_set.b.length ).to.be 0

describe 'join(), multiple conditions', ->
  projects             = null
  views                = null
  images               = null
  
  merge_views_images   = null
  
  views_and_images     = null
  views_and_images_set = null
  
  views_images         = null
  views_images_set     = null
  
  images_views         = null
  images_views_set     = null
  
  views_or_images      = null
  views_or_images_set  = null
  
  expected             = null
  expected_left        = null
  expected_right       = null
  expected_full        = null
  
  on_add               = null
  on_remove            = null
  on_update            = null
  
  describe 'joining views and images', ->
    it 'should join non-empty sets of views and images', ( done ) ->
      # The set "projects" is not used in this test suite, it is only defined to help understand the test
      projects = rs.set [
        { id: 1, name: 'First project' }
        { id: 2, name: 'Second project' }
      ]
      
      views = rs.set [
        { project_id: '1', id: 1, name: 'Project 1 view 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2' }
        { project_id: '2', id: 1, name: 'Project 2 view 1' }
        
      ], { key: [ 'project_id', 'id' ] }
      
      images = rs.set [
        { project_id: '1', view_id: 1, id: 1, name: 'Project 1 view 1 image 1' }
        { project_id: '2', view_id: 1, id: 1, name: 'Project 2 view 1 image 1' }
        { project_id: '2', view_id: 1, id: 2, name: 'Project 2 view 1 image 2' }
        { project_id: '2', view_id: 2, id: 1, name: 'Project 2 view 2 image 1' }
        
      ], { key: [ 'project_id', 'view_id', 'id' ] }
      
      merge_views_images = ( view, image ) ->
        if ( view and image )
          extend {}, view, { image_id: image.id, image_name: image.name }
        else
          view or { project_id: image.project_id, id: image.view_id, image_id: image.id, image_name: image.name }
      
      # inner join
      views_and_images = views.join(
          images
          
          [ 'project_id', [ 'id', 'view_id' ] ]
          
          merge_views_images
          
          { key: [ 'project_id', 'id', 'image_id' ] }
          
        ).trace 'views and images trace' # Note: cannot put _on() on union output of join(), trace() or other pipelet is required for that
      
      views_and_images_set = views_and_images.set()
      
      views_and_images._on 'add',    ( values, options ) -> on_add    && on_add    values, options
      views_and_images._on 'remove', ( values, options ) -> on_remove && on_remove values, options
      views_and_images._on 'update', ( values, options ) -> on_update && on_update values, options
      
      expected = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
      ]
      
      views_and_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same on downstream set', ( done ) ->
      views_and_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same for a left join, displaying one view with no image', ( done ) ->
      # left join
      views_images = views.join(
          images
          
          [ 'project_id', [ 'id', 'view_id' ] ]
          
          merge_views_images
          
          { left: true, key: [ 'project_id', 'id', 'image_id' ] }
          
        ).trace 'views images trace' # Note: cannot put _on() on union output of join(), trace() or other pipelet is required for that
      
      views_images_set = views_images.set()
      
      expected_left = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
      ]
      
      views_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same on (left join) downstream set', ( done ) ->
      views_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same for a right join, displaying one image associated with no view', ( done ) ->
      # right join
      images_views = views.join(
          images
          
          [ 'project_id', [ 'id', 'view_id' ] ]
          
          merge_views_images
          
          { right: true, key: [ 'project_id', 'id', 'image_id' ] }
          
        ).trace 'images views trace' # Note: cannot put _on() on union output of join(), trace() or other pipelet is required for that
      
      images_views_set = images_views.set()
      
      expected_right = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2,                           image_id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      images_views._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same on (right join) downstream set', ( done ) ->
      images_views_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same for a full outer join, showing orphan view and image', ( done ) ->
      # full outer join
      views_or_images = views.join(
          images
          
          [ 'project_id', [ 'id', 'view_id' ] ]
          
          merge_views_images
          
          { outer: true, key: [ 'project_id', 'id', 'image_id' ] }
          
        ).trace 'views or images trace' # Note: cannot put _on() on union output of join(), trace() or other pipelet is required for that
      
      views_or_images_set = views_or_images.set()
      
      expected_full = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2,                           image_id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      views_or_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
    
    it 'should do the same on (outer join) downstream set', ( done ) ->
      views_or_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
  
  describe 'adding 3 images to empty view', ->
    it 'should add 3 images (inner join)', ( done ) ->
      images._add [
        { project_id: '1', view_id: 2, id: 1, name: 'Project 1 view 2 image 1' }
        { project_id: '1', view_id: 2, id: 2, name: 'Project 1 view 2 image 2' }
        { project_id: '1', view_id: 2, id: 3, name: 'Project 1 view 2 image 3' }
      ]
      
      expected.push(
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 3, image_name: 'Project 1 view 2 image 3' }
      )
      
      views_and_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same on (inner join) downstream set', ( done ) ->
      views_and_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same for a left join, updating orphan view with 3 images', ( done ) ->
      expected_left = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
      ]
      
      views_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same on (left join) downstream set', ( done ) ->
      views_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same for a right join, adding 3 images', ( done ) ->
      expected_right = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2,                           image_id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      images_views._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same on (right join) downstream set', ( done ) ->
      images_views_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same for a full outer join, updating orphan view with 3 images', ( done ) ->
      expected_full = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2,                           image_id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      views_or_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
    
    it 'should do the same on (outer join) downstream set', ( done ) ->
      views_or_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
  
  describe 'adding two views, on for on orphan image, another with no image', ->
    it 'should add 1 image (inner join)', ( done ) ->
      views._add [
        { project_id: '2', id: 2, name: 'Project 2 view 2' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      ]
      
      expected.push(
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
      )
      
      views_and_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same on (inner join) downstream set', ( done ) ->
      views_and_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should add one image and one view (left join)', ( done ) ->
      expected_left.push(
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      )
      
      views_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same on (left join) downstream set', ( done ) ->
      views_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should update one image with its view (right join)', ( done ) ->
      expected_right = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      images_views._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same on (right join) downstream set', ( done ) ->
      images_views_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should update one image with its view, and add orphan view (full outer join)', ( done ) ->
      expected_full = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2, name: 'Project 1 view 2', image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1, name: 'Project 2 view 1', image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      ]
      
      views_or_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
    
    it 'should do the same on (outer join) downstream set', ( done ) ->
      views_or_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
  
  describe 'removing 2 views', ->
    it 'should remove 5 images (inner join)', ( done ) ->
      views._remove [
        { project_id: '1', id: 2, name: 'Project 1 view 2' }
        { project_id: '2', id: 1, name: 'Project 2 view 1' }
      ]
      
      expected = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      views_and_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same on  (inner join) downstream set', ( done ) ->
      views_and_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same on  (left join)', ( done ) ->
      expected_left = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      ]
      
      views_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same on (left join) downstream set', ( done ) ->
      views_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should update 5 images to remove view names (right join)', ( done ) ->
      expected_right = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2,                           image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2,                           image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2,                           image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 1,                           image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1,                           image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      images_views._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same on (right join) downstream set', ( done ) ->
      images_views_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same (full outer join)', ( done ) ->
      expected_full = [
        { project_id: '1', id: 1, name: 'Project 1 view 1', image_id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', id: 2,                           image_id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '1', id: 2,                           image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2,                           image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 1,                           image_id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', id: 1,                           image_id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', id: 2, name: 'Project 2 view 2', image_id: 1, image_name: 'Project 2 view 2 image 1' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      ]
      
      views_or_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
    
    it 'should do the same on (outer join) downstream set', ( done ) ->
      views_or_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
  
  describe 'removing 5 images', ->
    it 'should remove the last two images (inner join)', ( done ) ->
      images._remove [
        { project_id: '1', view_id: 1, id: 1, image_name: 'Project 1 view 1 image 1' }
        { project_id: '1', view_id: 2, id: 1, image_name: 'Project 1 view 2 image 1' }
        { project_id: '2', view_id: 1, id: 1, image_name: 'Project 2 view 1 image 1' }
        { project_id: '2', view_id: 1, id: 2, image_name: 'Project 2 view 1 image 2' }
        { project_id: '2', view_id: 2, id: 1, image_name: 'Project 2 view 2 image 1' }
      ]
      
      expected = []
      
      views_and_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do the same on  (inner join) downstream set', ( done ) ->
      views_and_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should remove last 2 images, leaving two more orphan views (left join), 1 remove and 1 update', ( done ) ->
      expected_left = [
        { project_id: '1', id: 1, name: 'Project 1 view 1' }
        { project_id: '2', id: 2, name: 'Project 2 view 2' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      ]
      
      views_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same on (left join) downstream set', ( done ) ->
      views_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should remove 5 images, leaving two orphan images (right join)', ( done ) ->
      expected_right = [
        { project_id: '1', id: 2,                           image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2,                           image_id: 3, image_name: 'Project 1 view 2 image 3' }
      ]
      
      images_views._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same on (right join) downstream set', ( done ) ->
      images_views_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should remove 5 images, leaving 2 more orphan views (full outer join), 1 remove and 1 update', ( done ) ->
      expected_full = [
        { project_id: '1', id: 1, name: 'Project 1 view 1' }
        { project_id: '1', id: 2,                           image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2,                           image_id: 3, image_name: 'Project 1 view 2 image 3' }
        { project_id: '2', id: 2, name: 'Project 2 view 2' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      ]
      
      views_or_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
    
    it 'should do the same on (outer join) downstream set', ( done ) ->
      views_or_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
  
  describe 'removing last 3 views', ->
    it 'should do nothing (inner join)', ( done ) ->
      views._remove [
        { project_id: '1', id: 1, name: 'Project 1 view 1' }
        { project_id: '2', id: 2, name: 'Project 2 view 2' }
        { project_id: '2', id: 3, name: 'Project 2 view 3' }
      ]
      
      views_and_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do nothing (inner join) downstream set', ( done ) ->
      views_and_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should remove last  views (left join)', ( done ) ->
      expected_left = []
      
      views_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do the same on (left join) downstream set', ( done ) ->
      views_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do nothing, leaving two orphan images (right join)', ( done ) ->
      images_views._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same on (right join) downstream set', ( done ) ->
      images_views_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should remove 3 views, leaving 2 orphan images', ( done ) ->
      expected_full = [
        { project_id: '1', id: 2,                           image_id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', id: 2,                           image_id: 3, image_name: 'Project 1 view 2 image 3' }
      ]
      
      views_or_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
    
    it 'should do the same on (outer join) downstream set', ( done ) ->
      views_or_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
  
  describe 'removing last 2 images', ->
    it 'do nothing (inner join)', ( done ) ->
      images._remove [
        { project_id: '1', view_id: 2, id: 2, image_name: 'Project 1 view 2 image 2' }
        { project_id: '1', view_id: 2, id: 3, image_name: 'Project 1 view 2 image 3' }
      ]
      
      views_and_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do nothing (inner join) downstream set', ( done ) ->
      views_and_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected, values
    
    it 'should do nothing (left join)', ( done ) ->
      views_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should do nothing (left join) downstream set', ( done ) ->
      views_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_left, values
    
    it 'should remove last 2 orphan images (right join)', ( done ) ->
      expected_right = []
      
      images_views._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same on (right join) downstream set', ( done ) ->
      images_views_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_right, values
    
    it 'should do the same (full outer join)', ( done ) ->
      expected_full = []
      
      views_or_images._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
    
    it 'should do the same on (outer join) downstream set', ( done ) ->
      views_or_images_set._fetch_all ( values ) -> check done, ->
        compare_expected_values expected_full, values
  
  describe 'checking anti-state of downstream sets are empty', ->
    it 'should have nothing in (inner join)      downstream set anti-state', () ->
      expect( views_and_images_set.b.length ).to.be 0
    
    it 'should have nothing in (left join)       downstream set anti-state', () ->
      expect( views_images_set.b.length ).to.be 0
    
    it 'should have nothing in (right join)      downstream set anti-state', () ->
      expect( images_views_set.b.length ).to.be 0
    
    it 'should have nothing in (full outer join) downstream set anti-state', () ->
      expect( views_or_images_set.b.length ).to.be 0
