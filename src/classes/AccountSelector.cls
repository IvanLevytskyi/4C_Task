/**
 * @description Selector class for Account
 */
public with sharing class AccountSelector {

    /**
     * @description Get Giphy_ID__c by account Id
     *
     * @param recordId
     *
     * @return String value of Giphy_ID__c
     */
    public static String getGiphyIdByRecordId(Id recordId) {
        return [SELECT Giphy_ID__c FROM Account WHERE Id = :recordId][0].Giphy_ID__c;
    }
}