import { LightningElement,api } from 'lwc';

export default class ShowBookDetails extends LightningElement {
    @api bookName

    connectedCallback(){
        console.log('Child received Book Name:', this.bookName);
        this.loadBookNameForDetails();
    }

    loadBookNameForDetails(){
        console.log(`Book Name passed by Parent is: {this.bookName}`);
    }
}