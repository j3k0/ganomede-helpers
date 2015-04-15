# Ganomede Helpers

## Install

Install with `npm install --save ganomede-helpers`

## Usage

```js
var helpers = require("ganomede-helpers");
```

## helpers.restify.middlewares.authdb

Simplifies the integration of restify servers with authdb.

### create: function(options)

**Options**:

 * authdbClient [required]: a authdb client as created using the authdb library
 * log: a bunyan style logger object

**Returns** a restify middleware function. This function requires `authToken` as a request parameter and fills the virtual `user` query parameter with the full user account details.

### example
```js
authMW = helpers.restify.middlewares.create({
  authdbClient: myClient
});
app.get "/auth/:authToken/games", authMW, getGames
```

## helpers.links.ServiceEnv

Conveniant access to service links environment variables, compatible with docker links.

### exists: function(name, port) : boolean

 * **name**: Name of the service to link
 * **port**: Default port of the service

**Returns** true if both the `_PORT` and `_ADDR` environemnt variables are set.

### host: function(name, port) : string

 * **name**: Name of the service to link
 * **port**: Default port of the service

**Returns** the `_ADDR` environemnt variable, or `127.0.0.1`

### port: function(name, port) : int

 * **name**: Name of the service to link
 * **port**: Default port of the service

**Returns** the `_PORT` environemnt variable (casted to int), or the `port` parameter.

### url: function(name, port) : string

generates and `http://` URL using `host` and `port`.

### example
```js
var couch = myLib.connect(helpers.links.ServiceEnv.url('COUCH_GAMES', 5984))
```

## helpers.Notification

Helper class allowing easier sending of notifications from ganomede services.

### example
```js
var notification = new helpers.Notification(
  from: 'ganomede-service',
  to: 'username',
  type: 'sample-notification',
  data: {sample: 'data'},
  secret: 'api-secret'
);

var sendNotification = helpers.Notification.sendFn();

sendNotification(notification, function (err, response) {
  // ...
});
```
