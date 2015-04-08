# Ganomede Helpers

## Install

Install with `npm install --save ganomede-helpers`

## Usage

```js
var helpers = require("ganomede-helpers");
```

## helpers.restify.middlewares.authdb

### create: function(options)

**Options**:

 * authdbClient [required]: a authdb client as created using the authdb library
 * log: a bunyan style logger object

**Returns** a restify middleware function. This function requires `authToken` as a request parameter and fills the virtual `user` query parameter with the full user account details.
