import LightningDatatable from 'lightning/datatable';
import customTypeImage from './customTypeImage';
export default class CustomLightningDatatable extends LightningDatatable {
static customTypes = {
    image: {
        template: customTypeImage    }
  }
}