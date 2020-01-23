import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getGiphyId from '@salesforce/apex/RandomGifController.getGiphyId';

const URL_PREFIX = 'https://media.giphy.com/media/';
const URL_SUFFIX = '/giphy.gif';


export default class RandomGifLwc extends LightningElement {
    @api recordId;
    @track gifUrl;
    @track isLoading = true;

    get showDefaultIcon() {
        return !this.isLoading && !this.gifUrl;
    }

    connectedCallback() {
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