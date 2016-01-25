'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _rockauthClient = require('./rockauth-client.js');

var _rockauthClient2 = _interopRequireDefault(_rockauthClient);

var _rockauthTags = require('./rockauth-tags.js');

var _rockauthTags2 = _interopRequireDefault(_rockauthTags);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = { tags: _rockauthTags2.default, rockauthClient: _rockauthClient2.default };