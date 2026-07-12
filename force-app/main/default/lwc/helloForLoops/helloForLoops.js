import { LightningElement } from 'lwc';

export default class HelloForLoops extends LightningElement {

    carList =["Ford","Audi","Honda","Hundayi","Mazda","Toyota"];

    ceoList=[
        {
            id:1,
            company:"Google",
            name:"Sundar Pichai"

        },
        {
            id:2,
            company:"Apple Inc.",
            name:"Tim Cook"
        },
        {
            id:3,
             company:"Facebook",
             name:"Mark Zuckerberg"

        },
        {id:4,
             company:"Microsoft",
             name:"Bill Gates"
        },
        {
            id:5,
             company:"Amazon",
             name:"Jeff Bezos"
        }
    ]
}