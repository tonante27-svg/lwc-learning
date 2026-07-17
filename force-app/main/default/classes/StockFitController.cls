/**
 * @description Controller for stock information retrieval
 */
public with sharing class StockFitController {
    /**
     * @description Validates a stock symbol against an external API endpoint
     * @param stockSymbol The stock ticker symbol to validate
     * @return The validated stock symbol
     */
    @AuraEnabled
    public static Boolean stockSymbolExists(String stockSymbol){
        validateInput(stockSymbol);
         //Set up requst object
            HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'callout:Stock_Fit_API/api/lookup/symbol?symbol=' +
            EncodingUtil.urlEncode(stockSymbol, 'UTF-8'));
        req.setMethod('GET');
        try {
            HttpResponse resp = new Http().send(req);

            System.debug('Status Code = ' + resp.getStatusCode());
            System.debug('Status = ' + resp.getStatus());
            System.debug('Body = ' + resp.getBody());

            if (resp.getStatusCode() == 200) {
                return true;
            }

            throw new AuraHandledException(
                'HTTP ' +
                resp.getStatusCode() +
                ' Body: ' +
                resp.getBody()
            );
        }catch (CalloutException ex) {
            System.debug('CALL OUT EXCEPTION: ' + ex.getMessage());
            throw new AuraHandledException(
                'CalloutException: ' + ex.getMessage()
            );

        }catch(Exception ex){
            if(ex instanceof AuraHandledException){
                throw ex;
            }
            throw new AuraHandledException(ex.getMessage());
        }
    }
    /**
     * @description Retrieves stock information for a given symbol from an external API endpoint
     * @param symbol The stock ticker symbol
     * @return Map containing the stock data
     */
    @AuraEnabled 
    public static Map<String, Object> getStockInfo(String symbol){
        //Validate that symbol and endpoint ar not empty
        validateInput(symbol);
        //Set up requst object
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'callout:Stock_Fit_API/api/company/details?symbol=' +
            EncodingUtil.urlEncode(symbol, 'UTF-8'));
        req.setMethod('GET');
        HttpResponse resp = new Http().send(req);
        if(resp.getStatusCode() == 200){
            return (Map<String,Object>) JSON.deserializeUntyped(resp.getBody());
        }else {
            throw new AuraHandledException('Error ' + resp.getStatusCode() + ':' + resp.getBody());
        }
    }

    /**
     * @description Validates required input values for stock requests
     * @param symbol The stock ticker symbol
     * @param endpoint The API endpoint URL
     */
    public static void validateInput(String symbol){
        if(String.isBlank(symbol)){
            throw new AuraHandledException('Stock symbol is required');
        }
    }
}
