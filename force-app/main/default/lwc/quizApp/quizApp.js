import { LightningElement } from 'lwc';

export default class QuizApp extends LightningElement {
    selectedanswer={};// for stroing answers
    myQuestions = [{

        id: "Question1",
        question:"Which onbe of the following is not a template loop?",
        answers:{
            a:"for:each",
            b:"iterator",
            c:"map loop"
        },
        correctAnswer: "c"
    },
    {

        id: "Question2",
        question:"Which of the files is an invalid LWC component folder?",
        answers:{
            a:".svg",
            b:".apex",
            c:".js"
        },
        correctAnswer: "b"
    },{

        id: "Question3",
        question:"Which of the following is not a directive?",
        answers:{
            a:"for:each",
            b:"LWC:if",
            c:"@track"
        },
        correctAnswer: "c"
    },
    ]
    
    // change Handler
    changeHandler(event){
        console.log(event.target.name)
        console.log(event.target.value)
       const{name,value} = event.target;
       this.selectedanswer={...this.selectedanswer,[name]:value}
    }

    submitHanlder(event){

    }

    resetHandler(event){


        get allNotSelected(){
            // Keys = question id
            // Values = question selected answer
            // if all values are not selected return false
            // if any value is selected return true
            return !(Object.keys(this.selectedanswer.length === this.myQuestions.legnth))
        }
    }
}