# Ganomede Helpers

## Install

Install with `npm install --save ganomede-helpers`

## Usage

```js
var helpers = require("ganomede-helpers");
```

## helpers.restify.middlewares.authdb

Simplifies the integration of restify servers with authdb. Will check `req.params.authToken` agains passed in [authdb client](https://github.com/j3k0/node-authdb) and fill out `req.params.user` with result. Replies with HTTP 400 in case of missing token; or 401 in case of error or missing account.

### create: function(options)

**Options**:

 * `authdbClient` [required]: a authdb client as created using the authdb library
 * `secret`: allows "spoofing" `req.params.user` in case `authToken` matches `${secret}.${username}` pattern. Will skip validating token and run following instead:

 ``` js
  req.params.user = {
    _secret: true
    username: spoofUsername // second part of token
  }
 ```
 * `log`: a bunyan style logger object

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
// Create notificaiton.
var notification = new helpers.Notification(
  // Fill in required fields:
  from: 'ganomede-service',
  to: 'username',
  type: 'sample-notification',
  // Fill in optional fields as neccessary:
  data: {sample: 'data'},
  secret: 'api-secret' // defaults to process.env.API_SECRET
);

// send() function bound to NOTIFICATION service address
// (set as ENV variable retrieved by ServiceEnv class).
var sendNotification = helpers.Notification.sendFn();

// Send notification.
sendNotification(notification, function (err, response) {
  // When notification is sent, it will have `id` and `timestamp`
  // set by notification service. For more details, see:
  // https://github.com/j3k0/ganomede-notifications#send-a-message-post.
});
```
