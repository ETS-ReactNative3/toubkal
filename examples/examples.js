/*  examples.js

    Serve all examples assets and datasets from virtual http servers
*/
module.exports = function( servers ) {
  'use strict';
  
  var rs = require( 'toubkal' );
  
  require( 'toubkal/lib/server/file.js'                 );
  require( 'toubkal/lib/socket_io/socket_io_clients.js' );
  
  /* ------------------------------------------------------------------------------------
     de&&ug()
  */
  var de = true, ug = rs.RS.log.bind( null, 'examples' );
  
  /* ------------------------------------------------------------------------------------
     Build toubkal-min.js then listen on servers
  */
  var assets = require( 'toubkal/lib/server/client_assets.js' )
    , toubkal_min = assets.toubkal_min()
  ;
  
  // Listen when lib/toubkal-min.js is ready
  servers.http_listen( toubkal_min );
  
  /* ------------------------------------------------------------------------------------
     Watch all directories from here
  */
  var directories = rs.set( [ { path: '' } ] ).union()
    , entries     = directories.watch_directories( { base_directory: __dirname } )
  ;
  
  entries
    .filter( [ { type: 'directory' } ] )
    ._add_destination( directories ) // loopback to watch all subdirectories recursively
  ;
  
  /* ------------------------------------------------------------------------------------
     Load and Serve Static Assets
  */
  var files = entries
    .filter( [
      { extension: 'html' },
      { extension: 'css'  },
      { extension: 'js'   },
      { extension: 'json' }
    ] )
    .watch( { base_directory: __dirname } )
    .union( [ toubkal_min ] )
  ;
  
  // Serve assets to http servers
  files.serve( servers );
  
  /* ------------------------------------------------------------------------------------
     The database, made of all found json files
  */
  var tables = entries
    .filter( [ { extension: 'json' } ] )
    
    .alter( function( table ) {
      var path = table.path
        , flow = path.split( '.' )
      ;
      
      flow.pop(); // remove 'json' extension
      
      flow = flow.join( '.' ); // e.g. datasets/sales
      
      return { flow: '/table', 'name': flow, 'path': path };
    }, { no_clone: true } )
    
    .trace( 'database tables' )
  ;
  
  var database = rs.dispatch( tables, function( source, options ) {
    var flow = this.name;
    
    return source
      .flow( flow )
      .configuration( { 'filepath': this.path, 'flow': flow, 'base_directory': __dirname  } )
    ;
  } );
  
  // Serve database to socket.io clients
  var clients_input = rs.union( [ database, tables ] );
  
  var clients_output = clients_input
     .dispatch( servers.socket_io_clients(), function( source, options ) {
       
       return this.socket._add_source( source );
     } )
  ;
  
  // Make encapsulated dataflow for data processors
  var clients = rs.encapsulate( clients_input, clients_output );
  
  // Require examples' data processors
  require( './teaser/data' )( database, clients );
} // module.exports
