RSVP = require "rsvp"

RSVP.Promise::done = (done) -> @then done
RSVP.Promise::fail = (fail) -> @then null, fail

module.exports = RSVP