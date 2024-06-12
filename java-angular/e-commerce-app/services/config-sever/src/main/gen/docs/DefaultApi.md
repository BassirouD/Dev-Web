# DefaultApi

All URIs are relative to *https://e_commerce_app*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**createOrder**](DefaultApi.md#createOrder) | **POST** /api/v1/orders | POST api/v1/orders |


<a name="createOrder"></a>
# **createOrder**
> Integer createOrder(orderRequest)

POST api/v1/orders

### Example
```java
// Import classes:
import org.openapitools.client.ApiClient;
import org.openapitools.client.ApiException;
import org.openapitools.client.Configuration;
import org.openapitools.client.models.*;
import org.openapitools.client.api.DefaultApi;

public class Example {
  public static void main(String[] args) {
    ApiClient defaultClient = Configuration.getDefaultApiClient();
    defaultClient.setBasePath("https://e_commerce_app");

    DefaultApi apiInstance = new DefaultApi(defaultClient);
    OrderRequest orderRequest = new OrderRequest(); // OrderRequest | 
    try {
      Integer result = apiInstance.createOrder(orderRequest);
      System.out.println(result);
    } catch (ApiException e) {
      System.err.println("Exception when calling DefaultApi#createOrder");
      System.err.println("Status code: " + e.getCode());
      System.err.println("Reason: " + e.getResponseBody());
      System.err.println("Response headers: " + e.getResponseHeaders());
      e.printStackTrace();
    }
  }
}
```

### Parameters

| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **orderRequest** | [**OrderRequest**](OrderRequest.md)|  | |

### Return type

**Integer**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |

