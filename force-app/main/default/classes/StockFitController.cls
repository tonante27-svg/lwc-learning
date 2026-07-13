public with sharing class StockFitController {
   
    @AuraEnabled (cacheable=true)
    public static Map<String, Object> getStockInfo(String symbol, String endpointPath){

        if(String.isBlank(symbol)){
            throw new AuraHandledException('Stock symbol is required');
        }
        if(String.isBlank(endpointPath)){
            throw new AuraHandledException('Endpoint Pathis required');
        }
        //Set up requst object
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointPath + '?symbol=' + EncodingUtil.urlEncode(symbol, 'UTF-8'));
        req.setMethod('GET');
        HttpResponse resp = new Http().send(req);
        if(resp.getStatusCode() == 200){
            return (Map<String,Object>) JSON.deserializeUntyped(resp.getBody());
        }else {
            throw new AuraHandledException('Error ' + resp.getStatusCode() + ':' + resp.getBody());
        }
    }
}
