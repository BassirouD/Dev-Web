

# OrderRequest


## Properties

| Name | Type | Description | Notes |
|------------ | ------------- | ------------- | -------------|
|**id** | **Integer** |  |  [optional] |
|**reference** | **String** |  |  [optional] |
|**amount** | **Object** |  |  [optional] |
|**paymentMethod** | [**PaymentMethodEnum**](#PaymentMethodEnum) |  |  [optional] |
|**customerId** | **String** |  |  [optional] |
|**products** | [**List&lt;PurchaseRequest&gt;**](PurchaseRequest.md) |  |  [optional] |



## Enum: PaymentMethodEnum

| Name | Value |
|---- | -----|
| PAYPAL | &quot;PAYPAL&quot; |
| CREDIT_CARD | &quot;CREDIT_CARD&quot; |
| VISA | &quot;VISA&quot; |
| MASTER_CARD | &quot;MASTER_CARD&quot; |
| BITCOIN | &quot;BITCOIN&quot; |



