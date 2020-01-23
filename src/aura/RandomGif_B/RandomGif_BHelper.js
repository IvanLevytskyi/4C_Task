({
    URL_PREFIX: 'https://media.giphy.com/media/',

    URL_SUFFIX: '/giphy.gif',

    retrieveGiphyId: function (component) {
        component.set('v.isLoading', true);
        let action = component.get('c.getGiphyId');
        action.setParams({recordId: component.get('v.recordId')});
        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let giphyId = response.getReturnValue();
                component.set(
                    'v.gifUrl',
                    giphyId ? this.URL_PREFIX + giphyId + this.URL_SUFFIX : ''
                );
            } else if (state === 'ERROR') {
                let errorMessage = this.getErrorMessage(response);

                this.showToast('error', errorMessage);
                console.error(errorMessage);
            }

            component.set('v.isLoading', false);
        });
        $A.enqueueAction(action);
    },

    getErrorMessage: function (response) {
        let errorMessage, errors = response.getError();
        if (errors) {
            if (errors[0] && errors[0].message) {
                errorMessage = 'Error message:' + errors[0].message;
            }
        } else {
            errorMessage = 'Unknown error';
        }
        return errorMessage;
    },

    subscribeToPlatformEvents: function (component) {
        const empApi = component.find('empApi');
        const channel = '/event/Acc_Industry_Field__e';

        const module = {
            this_: this,
            component_: component
        }

        const messageCallback = function (eventReceived) {
            console.log('Received event ', JSON.stringify(eventReceived));
            if (eventReceived.data.payload.RecordId__c === module.component_.get('v.recordId')) {
                module.this_.retrieveGiphyId(module.component_);
            }
        }.bind(module);

        empApi.subscribe(channel, -1, $A.getCallback(messageCallback))
            .then(subscription => {
                console.log('Subscribed to channel ', subscription.channel);
            });
    },

    showToast: function (type, message) {
        let toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': message.toUpperCase(),
            'type': type,
            'message': message
        });
        toastEvent.fire();
    }
});