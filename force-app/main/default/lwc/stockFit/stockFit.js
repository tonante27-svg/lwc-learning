import {LightningElement} from 'lwc';
import validateStockSymbol from '@salesforce/apex/StockFitController.stockSymbolExists';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
export default class StockFit extends LightningElement {
    isSymbolValid;
    symbolInfo;
    symbol;
    isLoading = false;
    
    handleSymbolChange(event){
        console.log('Symbol Handler fired!');
        console.log(event.target);
        console.log(event.target.value);
        this.symbol = event.target.value;
        console.log(`Stock Symbol is: ${this.symbol} in HandleSymboldChange`);
    }

    async handleValidate(){
        if (!this.symbol) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Missing Symbol',
                    message: 'Please enter a stock symbol.',
                    variant: 'warning'
                })
            );
                return;
        }        
        this.symbol = this.symbol.trim().toUpperCase();
        console.log(`Stock Symbol is: ${this.symbol} in HandleValidate`);
        this.isSymbolValid = false;
        this.isLoading = true;
     try {        
            this.symbolInfo = await validateStockSymbol({ stockSymbol: this.symbol});
            console.log('Parent sending symbol:', this.symbol);
            this.error = undefined;
            this.isSymbolValid = true;
            this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Symbol: ${this.symbol} has been validated successfully!`,
                        variant: 'success',
                    }),
            );
        }catch (error) {
            console.error(error);
            console.error(error.body?.message);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Validation Failed',
                    message: error.body?.message || error.message,
                    variant: 'error'
                })
            );

        }finally{
                this.isLoading = false;
        }
    }
}