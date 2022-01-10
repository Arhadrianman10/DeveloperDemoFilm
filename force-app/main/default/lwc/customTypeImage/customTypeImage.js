import { LightningElement, api } from 'lwc';

export default class customTypeImage extends LightningElement {
    @api url;
    @api altText;
}