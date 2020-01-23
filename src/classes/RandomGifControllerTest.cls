/**
 * @description Unit test of RandomGifController
 */
@IsTest
private class RandomGifControllerTest {
    @IsTest
    static void testGetGiphyIdPositive() {
        // Positive testing scenario (there is a record with such Id)
        String gifId = 'IDXXXXXXXXX';
        Account testRecord = new Account(Name = 'Test Company Name', Industry = 'Agriculture', Giphy_ID__c = gifId);
        insert testRecord;

        System.assertEquals(gifId, RandomGifController.getGiphyId(testRecord.Id), 'Method must return Giphy_ID__c!');
    }

    @IsTest
    static void testGetGiphyIdNegative() {
        // Negative testing scenario (there is not any record with such id)
        Boolean thrownException = false;
        try {
            //Use Contact Id instead of Account's one
            RandomGifController.getGiphyId('0030Y00000UiCLHQA3');
        } catch (Exception e) {
            thrownException = true;
        }
        System.assertEquals(true, thrownException, 'Method must thrown an exception for invalid Id!');
    }
}