/**
 * @description GiphyApiCalloutMock used for unit testing of callouts to Giphy API
 */
@IsTest
global class GiphyApiCalloutMock implements HttpCalloutMock {
    global static String STATUS = 'OK';
    global static Integer STATUS_CODE = 200;
    global static String RESPONSE_BODY = '{"data":{"type":"gif","id":"lOgu23Ud7ArHmkz9Xi"}}';

    global HttpResponse respond (HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatus(STATUS);
        response.setStatusCode(STATUS_CODE);
        response.setBody(RESPONSE_BODY);
        return response;
    }
}