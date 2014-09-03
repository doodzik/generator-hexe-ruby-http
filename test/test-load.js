/*global describe, beforeEach, it*/
'use strict';
var assert = require('assert');

describe('generator hexe ruby http', function () {
  it('can be imported without blowing up', function () {
    var adapter = require('../adapter');
    assert(adapter !== undefined);
    var contract = require('../contract');
    assert(contract !== undefined);
  });
});
