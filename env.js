
url = require('url')
module.exports = (function ( ) {
  var redis_url = url.parse(process.env.REDIS_URL)
    , redis = url.parse(redis_url)
    , config = {port: redis.port, host: redis.hostname};
  return {
    port: process.env.PORT
  , redis_url: redis_url
  , redis: config
  };
})( );

