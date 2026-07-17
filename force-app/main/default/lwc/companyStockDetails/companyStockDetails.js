import { LightningElement ,api } from 'lwc';
import getStockDetails from '@salesforce/apex/StockFitController.getStockInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 

export default class CompanyStockDetails extends LightningElement {
    @api symbol;
    sDetails;
    error;

    connectedCallback(){
        console.log('Child received symbol:', this.symbol);
        this.loadStockDetails();
    }
   
    async loadStockDetails(){
        try{
            this.sDetails = await getStockDetails ({symbol: this.symbol});
            this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Details retrieved for ${this.symbol}`,
                        variant: 'success',
                    }),
            );
        }catch(error){
            this.error = error;
            this.sDetails = undefined;
            this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error validating symbol',
                        message: error.body?.message || 'Check browser console for details.' ,
                        variant: 'error',
                    }),
            );
        }
    }
    
}