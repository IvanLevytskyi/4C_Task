trigger AccountTrigger on Account (after update) {
    if (Trigger.OperationType == TriggerOperation.AFTER_UPDATE) {
        new AccountTriggerHandler().onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}