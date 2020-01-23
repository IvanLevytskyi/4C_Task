({
    doInit: function (component, event, helper) {
        helper.retrieveGiphyId(component);
        helper.subscribeToPlatformEvents(component);
    }
});