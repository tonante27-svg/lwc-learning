public with sharing class StockFitController {
   
    @AuraEnabled (cacheable=true)
    public static Map<String, Object> getStockInfo(String symbol, endpointPath: endpointPath){

        if(String.isBlank(symbol)){
                throw new AuraHandledException('Stock symbol is required');
            }
            if(String.isBlank(endpointPath)){
                throw new AuraHandledException('Endpoint Pathis required');
            }
            //Set up requst object
            HttpRequest req = new HttpRequest();
            req.SetMehtod('GET');
            req.setEndpoint('callout:Stock_Fit_API/v1/api/company/details?symbol=' + 
                    EncodingUtil.urlEncode(symbol, 'UTF-8'));

            HTTPResponse resp = new Http().send(req);
            if(resp.getStatusCode == 200){
                return  (Map<Stirng,Object>)JSON.deserializeUntyed(resp.Body());
        }else{
            throw new AuraEnabledExcception('Error '+resp.getStatusCode() + ':'+resp.Body());
        }
    }
}