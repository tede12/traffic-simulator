"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
var _ApiClient = _interopRequireDefault(require("../ApiClient"));
var _ErrorResponse = _interopRequireDefault(require("../model/ErrorResponse"));
var _PathResponse = _interopRequireDefault(require("../model/PathResponse"));
function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return _typeof(key) === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (_typeof(input) !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (_typeof(res) !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); } /**
                                                                                                                                                                                                                                                                                                                                                                                               * ITAS API
                                                                                                                                                                                                                                                                                                                                                                                               * ITAS API Documentation
                                                                                                                                                                                                                                                                                                                                                                                               *
                                                                                                                                                                                                                                                                                                                                                                                               * The version of the OpenAPI document: 1.0.0
                                                                                                                                                                                                                                                                                                                                                                                               * 
                                                                                                                                                                                                                                                                                                                                                                                               *
                                                                                                                                                                                                                                                                                                                                                                                               * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
                                                                                                                                                                                                                                                                                                                                                                                               * https://openapi-generator.tech
                                                                                                                                                                                                                                                                                                                                                                                               * Do not edit the class manually.
                                                                                                                                                                                                                                                                                                                                                                                               *
                                                                                                                                                                                                                                                                                                                                                                                               */
/**
* PathFinder service.
* @module api/PathFinderApi
* @version 1.0.0
*/
var PathFinderApi = /*#__PURE__*/function () {
  /**
  * Constructs a new PathFinderApi. 
  * @alias module:api/PathFinderApi
  * @class
  * @param {module:ApiClient} [apiClient] Optional API client implementation to use,
  * default to {@link module:ApiClient#instance} if unspecified.
  */
  function PathFinderApi(apiClient) {
    _classCallCheck(this, PathFinderApi);
    this.apiClient = apiClient || _ApiClient.default.instance;
  }

  /**
   * Callback function to receive the result of the pathFinderRetrieve operation.
   * @callback module:api/PathFinderApi~pathFinderRetrieveCallback
   * @param {String} error Error message, if any.
   * @param {module:model/PathResponse} data The data returned by the service call.
   * @param {String} response The complete HTTP response.
   */

  /**
   * @param {Number} fromIntersection 
   * @param {Number} mapId 
   * @param {Number} toIntersection 
   * @param {module:api/PathFinderApi~pathFinderRetrieveCallback} callback The callback function, accepting three arguments: error, data, response
   * data is of type: {@link module:model/PathResponse}
   */
  _createClass(PathFinderApi, [{
    key: "pathFinderRetrieve",
    value: function pathFinderRetrieve(fromIntersection, mapId, toIntersection, callback) {
      var postBody = null;
      // verify the required parameter 'fromIntersection' is set
      if (fromIntersection === undefined || fromIntersection === null) {
        throw new Error("Missing the required parameter 'fromIntersection' when calling pathFinderRetrieve");
      }
      // verify the required parameter 'mapId' is set
      if (mapId === undefined || mapId === null) {
        throw new Error("Missing the required parameter 'mapId' when calling pathFinderRetrieve");
      }
      // verify the required parameter 'toIntersection' is set
      if (toIntersection === undefined || toIntersection === null) {
        throw new Error("Missing the required parameter 'toIntersection' when calling pathFinderRetrieve");
      }
      var pathParams = {};
      var queryParams = {
        'fromIntersection': fromIntersection,
        'mapId': mapId,
        'toIntersection': toIntersection
      };
      var headerParams = {};
      var formParams = {};
      var authNames = [];
      var contentTypes = [];
      var accepts = ['application/json'];
      var returnType = _PathResponse.default;
      return this.apiClient.callApi('/pathFinder/', 'GET', pathParams, queryParams, headerParams, formParams, postBody, authNames, contentTypes, accepts, returnType, null, callback);
    }
  }]);
  return PathFinderApi;
}();
exports.default = PathFinderApi;