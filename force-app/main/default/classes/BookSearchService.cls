/**
 * BookSearchService
 *
 * Provides utility methods for validating and processing book names
 * for use with the OpenLibrary search API.
 *
 * Methods:
 * - getBookInfoByName(String): Returns a processed book name suitable for the OpenLibrary search API.
 * - validateInput(String): Validates the provided book name.
 * - processStringForAPI(String): Replaces whitespace with '+' for query formatting.
 */
public with sharing class BookSearchService {
    
    /**
     * Returns a processed book name suitable for the OpenLibrary search API.
     *
     * @param bookName the book name to search for
     * @return the processed book name
     */
    @AuraEnabled
    public static String processBookName(String bookName){
        System.debug('Entered processBookName');
        System.debug(bookName);
        boolean isValidName  = false;
        isValidName = validateInput(bookName);
        if(isValidName){
            bookName = processStringForAPI(bookName);
            return bookName;
        }else{
            throw new AuraException('AuraException occurred: Book Name Invalid' );
        }   
    }

    /**
     * Validates the provided book name.
     *
     * @param bookName the book name to validate
     * @return true if the bookName is not null, empty, or whitespace only
     * @throws AuraHandledException if the input is invalid
     */
    public static Boolean validateInput(String bookName){
        if(!String.isBlank(bookName)){
            return true;
        }else{
            throw new AuraHandledException('Invalid book name');
        }
    }
   
    /**
     * Formats the provided book name for use in the OpenLibrary search API.
     *
     * @param bookName the original book name
     * @return the book name with whitespace replaced by '+' characters
     */
    public static String processStringForAPI(String bookName){
        if(bookName.indexOf('+') == -1 && bookName.trim().containsWhitespace()){
            bookName = bookName.trim().replaceAll('\\s+', '+');
        }
        return bookName;
    }
    
    /**
     * Fetches book information from an external API.
     *  //https://openlibrary.org/search.json?q=the+lord+of+the+rings
     * @param bookName the book name or symbol to query
     * @return a Map representation of the JSON response
     * @throws AuraHandledException when the HTTP callout fails
     */
    @AuraEnabled
    public static Map<String, Object> fetchBookInfo(String bookName){
        //Validate that bookName and endpoint ar not empty
        //Set up requst object
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'callout:Open_Library_API/search.json?q=' +
            EncodingUtil.urlEncode(bookName, 'UTF-8'));
        req.setMethod('GET');
        HttpResponse resp = new Http().send(req);
        if(resp.getStatusCode() == 200){
            return (Map<String,Object>) JSON.deserializeUntyped(resp.getBody());
        }else {
            throw new AuraHandledException('Error ' + resp.getStatusCode() + ':' + resp.getBody());
        }
    }
}