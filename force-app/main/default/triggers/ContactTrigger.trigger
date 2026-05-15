trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact con : Trigger.new) {
        if (String.isBlank(con.Email)) {
            con.addError('Email is required for all contacts, including Person Accounts.');
        }
        System.debug('Fired');
    }
}