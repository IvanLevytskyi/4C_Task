/**
 * @description Implementation of trigger handler for Account Object
 */
public with sharing class AccountTriggerHandler {
    // Constants
    private static final String URL_BASE = 'https://api.giphy.com/v1/gifs/random';

    // Constants with lazy loading
    private static final String API_KEY {
        get {
            return RandomGifSelector.getApiKey();
        }
    }

    private static final String EMAIL_RECEIVER_ID {
        get {
            return RandomGifSelector.getEmailReceiver();
        }
    }

    /**
     * @description Implementation of After Update Account Trigger context
     *
     * @param newList Trigger.new
     * @param oldMap Trigger.oldMap
     */
    public void onAfterUpdate(List<Account> newList, Map<Id, Account> oldMap) {
        Set<Id> accountIdsToUpdate = new Set<Id>();

        for (Account acc : newList) {
            if (acc.Industry != oldMap.get(acc.Id).Industry) {
                accountIdsToUpdate.add(acc.Id);
            }
        }

        if (!accountIdsToUpdate.isEmpty()) {
            populateGiphyIds(accountIdsToUpdate);
        }
    }

    /**
     * @description Method used for updating Account records with Giphy Id
     *
     * @param recordIds Set of Ids of Account record that must be updated
     * @param gifId Received random Giphy Id
     */
    private static void updateAccounts(Set<Id> recordIds, String gifId) {
        List<Account> accountsToUpdate = new List<Account>();

        for (Id accId : recordIds) {
            accountsToUpdate.add(new Account(Id = accId, Giphy_ID__c = gifId));
        }

        List<Database.SaveResult> accSaveResults = Database.update(accountsToUpdate, false);

        String emailBody = '';
        for (Database.SaveResult accSaveRes : accSaveResults) {
            if (!accSaveRes.isSuccess()) {
                // handle records error
                emailBody += '\nRecord Id: ' + accSaveRes.id + ' Message: ';

                for (Database.Error error : accSaveRes.getErrors()) {
                    emailBody += error.getMessage() + ' ';
                }

            }
        }

        if (String.isNotBlank(emailBody)) {
            sendErrorEmail(
                    'An error performed while updating accounts',
                    'Method name: AccountTriggerHandler.updateAccounts' + emailBody
            );
        }
    }

    /**
     * @description Wrapper for Http callouts to Giphy API
     *
     * @return http response
     */
    private static HttpResponse call() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL_BASE + '?api_key=' + API_KEY);
        request.setMethod('GET');

        return new Http().send(request);
    }

    /**
     * @description Method used for populating Giphy_Id__c field on Account
     *
     * @param accountIds
     */
    @future(callout=true)
    private static void populateGiphyIds(Set<Id> accountIds) {
        HttpResponse response = call();

        if (response.getStatus() == 'OK') {
            // It is bad practice to use fields in DTO with name similar to reserved keywords
            // That's why I replaced "id" to "gifId"
            String responseBody = response.getBody().replace('"id"', '"gifId"');

            GiphyDTO giphyObject = (GiphyDTO) JSON.deserialize(responseBody, GiphyDTO.class);

            String gifId = giphyObject.data.gifId;

            updateAccounts(accountIds, gifId);
        } else {
            // handle error
            sendErrorEmail(
                    'An error occurred while performing callout',
                    'Method name: AccountTriggerHandler.populateGiphyIds' +
                            '\nStatus: ' + response.getStatus() +
                            '\nStatus Code: ' + response.getStatus() +
                            '\nResponse Body: ' + response.getBody()
            );
        }
    }

    /**
     * @description Method used for sending notification emails about errors
     *
     * @param subject - email subject
     * @param message - email body
     */
    private static void sendErrorEmail(String subject, String message) {
        Messaging.SingleEmailMessage notificationEmail = new Messaging.SingleEmailMessage();
        notificationEmail.setSubject(subject);
        notificationEmail.setPlainTextBody(message);
        notificationEmail.setToAddresses(new List<String>{
                EMAIL_RECEIVER_ID
        });

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{
                notificationEmail
        });
    }
}