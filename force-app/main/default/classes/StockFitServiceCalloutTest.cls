/**
 * Test class for StockFitService callouts.
 */
 @IsTest
//============================ Callout Mock =======================
 private with sharing class StockFitServiceCalloutTest {
    /**
     * Mock implementation of HttpCalloutMock for testing StockFitService callouts.
     */
    private class StockFitServiceCalloutMock implements HttpCalloutMock {
        private Integer statusCode = 200;
        private String body = '{"success": true}';

        /**
         * Constructor for ExternalServiceCalloutMock.
         * @param statusCode The HTTP status code to return
         * @param body The response body to return
         */
        public StockFitServiceCalloutMock(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }

        /**
         * Generates a mock HTTP response.
         * @param request The HTTP request
         * @return The mock HTTP response
         */
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();

            response.setStatusCode(this.statusCode);
            response.setBody(this.body);
            response.setHeader('Content-Type', 'application/json');

            return response;
        }
    }

    //========================== Test Methods ==========================
    @IsTest
    static void testGetStockInfoNoSymbol() {
        // Arrange - Mock error response
        Test.setMock(HttpCalloutMock.class, 
                     new StockFitServiceCalloutMock(400, '{"error": "Symbol not found"}'));

        Test.startTest();
        try {
            StockFitController.getStockInfo('','/dummy/endpoint');
            System.assert(false, 'Should have thrown exception');
        } catch (Exception ex) {
               System.debug('Error:'+ex.getMessage());   
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetStockInfoNoEndpoint() {
        // Arrange - Mock error response
        Test.setMock(HttpCalloutMock.class, 
                     new StockFitServiceCalloutMock(400, '{"error": "Symbol not found"}'));

        Test.startTest();
        try {
            StockFitController.getStockInfo('AAPL','');
            System.assert(false, 'Should have thrown exception');
        } catch (Exception ex) {
               System.debug('Error:'+ex.getMessage());   
        }
        Test.stopTest();
    }
    @IsTest
    static void testStockSymbolExistsSuccess() {
        // Arrange - Mock successful response
        String mockJson = '{' +
            '"symbol": "AAPL",' +
            '"companyName": "Apple Inc.",' +
            '"price": 234.82' +
        '}';
        String endpointPath = '/api/lookup/symbol';
        String symbol = 'AAPL';
        
        Test.setMock(HttpCalloutMock.class, 
                     new StockFitServiceCalloutMock(200, mockJson));

        Test.startTest();
        Boolean result = StockFitController.stockSymbolExists(symbol,endpointPath);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(true, result, 'Stock symbol should match expected value');
    }
    @IsTest
    static void testStockSymbolExistsFailure() {
        // Arrange - Mock successful response
        String mockJson = '{' +
            '"symbol": "AAPL",' +
            '"companyName": "Apple Inc.",' +
            '"price": 234.82' +
        '}';
        String endpointPath = '/api/lookup/symbol';
        String symbol = 'AAGL';
        
        Test.setMock(HttpCalloutMock.class, 
                     new StockFitServiceCalloutMock(200, mockJson));

        Test.startTest();
        Boolean result = StockFitController.stockSymbolExists(symbol,endpointPath);
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(true, result, 'Stock symbol should match expected value');
    }
    @IsTest
    static void testGetStockInfoSuccess() {
        // Arrange - Mock successful response
        String mockJson = '{' +
            '"symbol": "AAPL",' +
            '"companyName": "Apple Inc.",' +
            '"price": 234.82' +
        '}';
        String endpointPath = '';
        
        Test.setMock(HttpCalloutMock.class, 
                     new StockFitServiceCalloutMock(200, mockJson));

        Test.startTest();
        Map<String, Object> result = StockFitController.getStockInfo('AAPL','/dummy/endpoint');
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('AAPL', result.get('symbol'), 'Stock symbol should match expected value');
    }
     @IsTest
    static void testGetStockInfoBadStatusCode() {
        // Arrange - Mock successful response
        String mockJson = '{' +
            '"symbol": "AAPL",' +
            '"companyName": "Apple Inc.",' +
            '"price": 234.82' +
        '}';
        String endpointPath = '';
        String result = '';
        
        Test.setMock(HttpCalloutMock.class, 
                     new StockFitServiceCalloutMock(400, mockJson));

        Test.startTest();
         try {
            StockFitController.getStockInfo('AAPL','/dummy/endpoint');
            System.assert(false, 'Should have thrown exception');
        } catch (Exception ex) {
               System.debug('Error:'+ex.getMessage());   
               result = ex.getMessage();
               System.debug('<< RESULT >> '+result);
        }        
        Test.stopTest();

        // Assert
        System.assertEquals('Script-thrown exception', result, 'Result should  be equal for thrown exception'); 
    }
}