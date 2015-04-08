# Ganomede Helpers

install with `npm install --save ganomede-helpers`

## restify.middlewares.authdb

### create(options)

Returns a restify middleware function, that requires `authToken` as a request parameter and fills the virtual `user` query parameter with the full user account details.


Options:

 * authdbClient [required]: a authdb client as created using the authdb library
 * log: a bunyan style logger object
