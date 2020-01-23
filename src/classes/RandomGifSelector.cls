/**
 * @description Selector class for RandomGif__mdt custom metadata type
 */
public with sharing class RandomGifSelector {
    // Constants
    private static final String API_KEY_NAME = 'API_KEY';
    private static final String EMAIL_RECEIVER_NAME = 'EMAIL_RECEIVER_ID';

    /**
     * @description get value from key-value pair stored in RandomGif__mdt record
     *
     * @param key - key, stored as DeveloperName in RandomGif__mdt
     *
     * @return related value
     */
    private static String getValueByKey(String key) {
        return [SELECT Value__c FROM RandomGif__mdt WHERE DeveloperName = :key][0].Value__c;
    }

    /**
     * @description retrieve API_KEY value for Giphy API
     *
     * @return API_KEY value
     */
    public static String getApiKey() {
        return getValueByKey(API_KEY_NAME);
    }

    /**
     * @description retrieve user id who will be an email receiver
     *
     * @return User Id
     */
    public static String getEmailReceiver() {
        return getValueByKey(EMAIL_RECEIVER_NAME);
    }
}