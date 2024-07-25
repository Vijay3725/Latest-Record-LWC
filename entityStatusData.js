import { LightningElement, track, wire} from 'lwc';
import getStatus from '@salesforce/apex/StatusCalculator.getStatus';
import {registerRefreshHandler} from 'lightning/refresh';

const COLUMNS = [
{label: 'Status', fieldName: 'status', type: 'text'},
{label: 'Count', fieldName: 'count', type: 'number'}
]

export default class EntityStatusData extends LightningElement {
    refreshHandlerId;



    connectedCallback(){
        this.refreshHandlerId = registerRefreshHandler(this, this.refreshHandler)
    }

    refreshHandler(){
        return new Promise(resolve=>{
            this.handleStatusCounts()
            resolve(true)
        })
    }
    columns = COLUMNS;
    @track counts;

    @wire(getStatus)
    handleStatusCounts({error, data}) {
        if (data) {
            console.log('Data retrieved: ', data);
            this.counts = data; 
            this.error = undefined;
        } else if (error) {
            console.error('Error retrieving status counts:', error);
            this.error = error; 
            this.counts = undefined;
        }
    }

   
}