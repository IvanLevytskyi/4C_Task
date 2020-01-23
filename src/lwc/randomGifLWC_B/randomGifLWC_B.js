import {LightningElement, api, track, wire} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import GIPHY_FIELD from '@salesforce/schema/Account.Giphy_ID__c';

const FIELDS = [GIPHY_FIELD];
const URL_PREFIX = 'https://media.giphy.com/media/';
const URL_SUFFIX = '/giphy.gif';


export default class RandomGifLwc extends LightningElement {
    @api recordId;
    @track gifUrl;
    @track isLoading = true;

    get showDefaultIcon() {
        return !this.isLoading && !this.gifUrl;
    }

    @wire(getRecord, { recordId: '$recordId', FIELDS })
    account({error, data}) {
        this.isLoading = false;
        if (data) {
            this.gifUrl = data ? URL_PREFIX + data + URL_SUFFIX : '';
        } else if (error) {
            this.showNotification('error', error);
            console.error(error);
        }
    }

    showNotification(mode, msg) {
        const evt = new ShowToastEvent({
            title: mode.toUpperCase(),
            message: msg,
            variant: mode,
        });
        this.dispatchEvent(evt);
    }
}