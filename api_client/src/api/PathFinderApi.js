/**
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


import ApiClient from "../ApiClient";
import ErrorResponse from '../model/ErrorResponse';
import PathResponse from '../model/PathResponse';

/**
* PathFinder service.
* @module api/PathFinderApi
* @version 1.0.0
*/
export default class PathFinderApi {

    /**
    * Constructs a new PathFinderApi. 
    * @alias module:api/PathFinderApi
    * @class
    * @param {module:ApiClient} [apiClient] Optional API client implementation to use,
    * default to {@link module:ApiClient#instance} if unspecified.
    */
    constructor(apiClient) {
        this.apiClient = apiClient || ApiClient.instance;
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
    pathFinderRetrieve(fromIntersection, mapId, toIntersection, callback) {
      let postBody = null;
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

      let pathParams = {
      };
      let queryParams = {
        'fromIntersection': fromIntersection,
        'mapId': mapId,
        'toIntersection': toIntersection
      };
      let headerParams = {
      };
      let formParams = {
      };

      let authNames = [];
      let contentTypes = [];
      let accepts = ['application/json'];
      let returnType = PathResponse;
      return this.apiClient.callApi(
        '/pathFinder/', 'GET',
        pathParams, queryParams, headerParams, formParams, postBody,
        authNames, contentTypes, accepts, returnType, null, callback
      );
    }


}