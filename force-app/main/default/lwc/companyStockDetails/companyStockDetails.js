import { LightningElement ,api,track } from 'lwc';
import getStockDetails from '@salesforce/apex/StockFitController.getStockInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 

export default class CompanyStockDetails extends LightningElement {
    @api symbol;
    @track sDetails;
    error;

   
    async handleStockInfo(event){
        this.symbol = event.target.value;
        this.symbol='AAPL'; // As a temp test.
        try{
            this.endpointPath = 'api/company/details?symbol='+this.symbol
            this.sDetails = await getStockDetails ({stockSymbol: this.symbol});
            this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Symbol; ${this.symbol} has been validated successfully!`,
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