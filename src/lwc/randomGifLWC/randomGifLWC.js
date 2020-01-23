import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getGiphyId from '@salesforce/apex/RandomGifController.getGiphyId';
import { subscribe } from 'lightning/empApi';

const URL_PREFIX = 'https://media.giphy.com/media/';
const URL_SUFFIX = '/giphy.gif';


export default class RandomGifLwc extends LightningElement {
    @api recordId;
    @track gifUrl;
    @track isLoading = true;
    @track channelName = '/event/Acc_Industry_Field__e';

    get showDefaultIcon() {
        return !this.isLoading && !this.gifUrl;
    }

    connectedCallback() {
        this.initGifUrl();

        const messageCallback = function(response) {
            if (response.data.payload.RecordId__c === this.recordId) {
                this.initGifUrl();
            }
        }.bind(this);

        subscribe(this.channelName, -1, messageCallback).then(response => {
            console.log('Successfully subscribed to : ', JSON.stringify(response.channel));
        });
    }

    initGifUrl() {
        getGiphyId({'recordId': this.recordId})
            .then(result => {
                this.gifUrl = result ? URL_PREFIX + result + URL_SUFFIX : '';
                this.isLoading = false;
            })
            .catch(error => {
                this.isLoading = false;
                this.showNotification('error', error.body.message);
                console.error(error);
            });
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