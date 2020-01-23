@IsTest
private class AccountTriggerTest {
    @TestSetup
    static void testSetup() {
        insert new Account(
                Name = 'Test Company Name',
                Industry = 'Agriculture'
        );
    }

    static Account getAccount() {
        return [SELECT Id, Industry, Giphy_ID__c FROM Account LIMIT 1];
    }

    @IsTest
    static void testPositiveScenario() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GiphyApiCalloutMock());
        Account originalAccount = getAccount();
        originalAccount.Industry = 'Banking';

        update originalAccount;
        Test.stopTest();

        Account updatedAccount = getAccount();
        System.assertNotEquals(updatedAccount.Giphy_ID__c, originalAccount.Giphy_ID__c, 'Giphy ID should be changed!');
    }

    @IsTest
    static void testNegativeScenario() {
        String badRequest = 'Bad Request';

        Test.startTest();

        GiphyApiCalloutMock.STATUS_CODE = 400;
        GiphyApiCalloutMock.STATUS = badRequest;
        GiphyApiCalloutMock.RESPONSE_BODY = badRequest;

        Test.setMock(HttpCalloutMock.class, new GiphyApiCalloutMock());

        Account originalAccount = getAccount();
        originalAccount.Industry = 'Banking';

        update originalAccount;

        Test.stopTest();

        Account updatedAccount = getAccount();

        System.assertEquals(originalAccount.Giphy_ID__c, updatedAccount.Giphy_ID__c, 'Giphy IDs should be the same!');
    }

    @IsTest
    static void testNothingToUpdate() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GiphyApiCalloutMock());
        Account originalAccount = getAccount();
        update originalAccount;
        Test.stopTest();

        Account updatedAccount = getAccount();
        System.assertEquals(updatedAccount.Giphy_ID__c, originalAccount.Giphy_ID__c, 'Giphy ID should not be changed!');
    }
}