import { LightningElement, api } from 'lwc';

export default class CustomTypeA extends LightningElement {
    @api url;
    @api altText;
}