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