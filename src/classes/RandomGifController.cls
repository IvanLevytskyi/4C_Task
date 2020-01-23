/**
 * @description Controller class for Aura Lightning component
 */
public with sharing class RandomGifController {
    /**
     * @description Method used for retrieving Giphy_ID__c for specified record
     *
     * @param recordId - Id of specified Account record
     *
     * @return String value of Giphy_ID__c for specified record
     */
    @AuraEnabled
    public static String getGiphyId(Id recordId) {
        try {
            return AccountSelector.getGiphyIdByRecordId(recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}