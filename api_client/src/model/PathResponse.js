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

import ApiClient from '../ApiClient';

/**
 * The PathResponse model module.
 * @module model/PathResponse
 * @version 1.0.0
 */
class PathResponse {
    /**
     * Constructs a new <code>PathResponse</code>.
     * @alias module:model/PathResponse
     * @param pathId {Number} 
     * @param path {Array.<String>} 
     */
    constructor(pathId, path) { 
        
        PathResponse.initialize(this, pathId, path);
    }

    /**
     * Initializes the fields of this object.
     * This method is used by the constructors of any subclasses, in order to implement multiple inheritance (mix-ins).
     * Only for internal use.
     */
    static initialize(obj, pathId, path) { 
        obj['pathId'] = pathId;
        obj['path'] = path;
    }

    /**
     * Constructs a <code>PathResponse</code> from a plain JavaScript object, optionally creating a new instance.
     * Copies all relevant properties from <code>data</code> to <code>obj</code> if supplied or a new instance if not.
     * @param {Object} data The plain JavaScript object bearing properties of interest.
     * @param {module:model/PathResponse} obj Optional instance to populate.
     * @return {module:model/PathResponse} The populated <code>PathResponse</code> instance.
     */
    static constructFromObject(data, obj) {
        if (data) {
            obj = obj || new PathResponse();

            if (data.hasOwnProperty('pathId')) {
                obj['pathId'] = ApiClient.convertToType(data['pathId'], 'Number');
            }
            if (data.hasOwnProperty('path')) {
                obj['path'] = ApiClient.convertToType(data['path'], ['String']);
            }
        }
        return obj;
    }

    /**
     * Validates the JSON data with respect to <code>PathResponse</code>.
     * @param {Object} data The plain JavaScript object bearing properties of interest.
     * @return {boolean} to indicate whether the JSON data is valid with respect to <code>PathResponse</code>.
     */
    static validateJSON(data) {
        // check to make sure all required properties are present in the JSON string
        for (const property of PathResponse.RequiredProperties) {
            if (!data[property]) {
                throw new Error("The required field `" + property + "` is not found in the JSON data: " + JSON.stringify(data));
            }
        }
        // ensure the json data is an array
        if (!Array.isArray(data['path'])) {
            throw new Error("Expected the field `path` to be an array in the JSON data but got " + data['path']);
        }

        return true;
    }


}

PathResponse.RequiredProperties = ["pathId", "path"];

/**
 * @member {Number} pathId
 */
PathResponse.prototype['pathId'] = undefined;

/**
 * @member {Array.<String>} path
 */
PathResponse.prototype['path'] = undefined;






export default PathResponse;
