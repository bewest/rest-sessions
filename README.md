# REST Sessions

[![Build Status](https://secure.travis-ci.org/smrchy/rest-sessions.png?branch=master)](http://travis-ci.org/smrchy/rest-sessions)


A REST interface to handle and share sessions between different app server platforms. Based on [redis-sessions](https://github.com/smrchy/redis-sessions).

## Installation

* Clone this repository
* Run `npm install` to install the dependencies.
* For the test make sure Redis runs locally and run `npm test`
* *Optional:* Modify the server port in server.js
* Start the server: `node server.js`


## Methods

### PUT /:app/create/:id

Create a session for :app and user :id

Parameters:

* `ip` The IP of the user
* `ttl` *optional* (default: 7200) The timeout for the session in seconds

Example:

```
PUT /mywebapp/create/user123?ip=192.168.99.22&ttl=86400
```

Response:

```
{"token": "KrxwdpUjoTQcYmMISjQE2C4drmXMhn5w2gX0388UySdPYoEJkPa74nhZhg3iaj7w"}

```

**Note:** You should save this token in a cookie and use it in subsequent requests to identify the user via `GET /:app/get/:token`

### GET /:app/get/:token

Get a session for :app and :token

Example:

```
GET /mywebapp/get/KrxwdpUjoTQcYmMISjQE2C4drmXMhn5w2gX0388UySdPYoEJkPa74nhZhg3iaj7w
```

Response: 

```
{
    "id": "user123",
    "r": 1,  // The read counter for this session
    "w": 1,  // The write counter for this session
    "ttl": 86400,
    "idle": 273,  // The idle time since the previous request
    "ip": "192.168.99.22"
}
```

### POST /:app/set/:token

Set some additional parameters for this session via a simple JSON object supplied via the POST body.

Example 1:

```
POST /mywebapp/set/KrxwdpUjoTQcYmMISjQE2C4drmXMhn5w2gX0388UySdPYoEJkPa74nhZhg3iaj7w
Content-Type: application/json

{
	"name": "Peter Smith",
	"unread_msgs": 12
}

```

Response:


```
{
    "id": "user123",
    "r": 1,
    "w": 2,
    "ttl": 86400,
    "idle": 211,
    "ip": "192.168.99.22",
    "d": {
        "name": "Peter Smith",
        "unread_msgs": 12,
        "age": 46
    }
}
```

Example 2:

* To remove a key set it to `null`
* If you omit a key it will stay untouched


```
POST /mywebapp/set/KrxwdpUjoTQcYmMISjQE2C4drmXMhn5w2gX0388UySdPYoEJkPa74nhZhg3iaj7w
Content-Type: application/json

{
	"name": "Bruce Dickinson",
	"unread_msgs": null,
	"job": "making gold records"
}

```

Response:

Note that the `unread_msgs` field was removed and `age` was not touched.

```
{
    "id": "user123",
    "r": 1,
    "w": 3,
    "ttl": 86400,
    "idle": 17,
    "ip": "192.168.99.22",
    "d": {
        "name": "Bruce Dickinson",
        "age": 46,
        "job": "making gold records"
    }
}
```


### GET /:app/activity

Get the number of active unique users (not sessions!) within the last *n* seconds

Parameters:

* `dt` Delta time. Amount of seconds to check (e.g. 600 for the last 10 min.)

Example:

```
GET /mywebapp/activity?dt=600
```

Response:

```
{"activity": 1}
```


### GET /:app/soapp

Get all sessions of an app that were active within the last *n* seconds

Parameters:

* `dt` Delta time. Amount of seconds to check (e.g. 600 for the last 10 min.)

Example:

```
GET /mywebapp/soapp?dt=600
```

Response:

```
{"sessions":
    [
        {
            "id": "user123",
            "r": 1,
            "w": 3,
            "ttl": 86400,
            "idle": 17,
            "ip": "192.168.99.22",
            "d": {
                "name": "Bruce Dickinson",
                "age": 46,
                "job": "making gold records"
            }
        },
        {
            "id": "user456",
            "r": 4,
            "w": 3,
            "ttl": 86400,
            "idle": 217,
            "ip": "192.168.99.25"
        }
    ]
}
```

### GET /:app/soid/:id

Get all sessions of a single id within an app.

Example:

```
GET /mywebapp/soid/user456
```

Response:

```
{"sessions":
    [
        {
            "id": "user456",
            "r": 4,
            "w": 3,
            "ttl": 86400,
            "idle": 217,
            "ip": "192.168.99.25"
        },
        {
            "id": "user456",
            "r": 42,
            "w": 31,
            "ttl": 86400,
            "idle": 23107,
            "ip": "10.0.2.45"
        }
    ]
}
```


### DELETE /:app/kill/:token

Kill a single session of an app.

Example:

```
DELETE /mywebapp/kill/KrxwdpUjoTQcYmMISjQE2C4drmXMhn5w2gX0388UySdPYoEJkPa74nhZhg3iaj7w
```

Response:

```
{"kill": 1}
```


### DELETE /:app/killsoid/:id

A single unique user id might have multiple sessions on different devices and/or browsers. This methods kills all sessions of an id.

Example:

```
DELETE /mywebapp/killsoid/user123
```

Response:

```
{"kill": 3}
```


### DELETE /:app/killall

Kills all sessions of an app.


Example:

```
DELETE /mywebapp/killall
```

Response:

```
{"kill": 42}
```
