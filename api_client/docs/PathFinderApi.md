# ItasApi.PathFinderApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**pathFinderRetrieve**](PathFinderApi.md#pathFinderRetrieve) | **GET** /pathFinder/ | 



## pathFinderRetrieve

> PathResponse pathFinderRetrieve(fromIntersection, mapId, toIntersection)



### Example

```javascript
import ItasApi from 'itas_api';

let apiInstance = new ItasApi.PathFinderApi();
let fromIntersection = 56; // Number | 
let mapId = 56; // Number | 
let toIntersection = 56; // Number | 
apiInstance.pathFinderRetrieve(fromIntersection, mapId, toIntersection, (error, data, response) => {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + data);
  }
});
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fromIntersection** | **Number**|  | 
 **mapId** | **Number**|  | 
 **toIntersection** | **Number**|  | 

### Return type

[**PathResponse**](PathResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

