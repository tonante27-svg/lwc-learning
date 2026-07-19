import {LightningElement} from 'lwc';
import validateBookName from '@salesforce/apex/BookSearchService.processBookName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
export default class BookSearchService extends LightningElement {
    bookName;
    isLoading = false;
    isBookNameValid = false
    error;
    processedName;

    handleBookNameChange(event){
        console.log('Book Name Handler fired!');
        console.log(event.target);
        console.log(event.target.value);
        this.bookName = event.target.value;
        console.log(`Book Name is: ${this.bookName} in handleBookNameChange`);
        
    }

    handleBookNameValidation(){
        console.log('Passing  Book Name To Child:', this.bookName);
        this.loadBookNameValidation();
        
    }

    async loadBookNameValidation(){
        try{
            console.log(`in loadBookNameValidation `);
            this.processedName = await validateBookName({bookName: this.bookName});
            this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: `Process book name is: ${this.processedName}`,
                        variant: 'success',
                    }),
            );
          this.isBookNameValid = true;  
        }catch(error){
            this.error = error;
            this.bookName = undefined;
            console.log('Entire error:', JSON.stringify(error));
            this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error validating book name',
                        message: error.body?.message || 'Check browser console for details.' ,
                        variant: 'error',
                    }),
            );
        }
    }
}