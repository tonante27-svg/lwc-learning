import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {
   
    fullname = "Zero to Hero";
    title = "Aura";
    changeHandler(event){
        this.title=event.target.value;
    }

     @track address={
         street:"34822 Marigold Ln",
         city:"Land O Lakes",
         state:"FL",
         zip:"33543"
    }

    trackHandler(event){
        // You can  Use this following code to avoid track decorator: this.address= {... this.address,"city":event.target.value};
        this.address.city = event.target.value;
    }

    /*** getters */
    users=["john","Ted","Smith"]
    num1 = 10;
    num2 = 20;
    get firstUser(){
        return this.users[0].toUpperCase();

    }
    get multiples(){
        return this.num1 * this.num2;
    }
}