import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getCalloutNames from '@salesforce/apex/ValidateJSONCreation.getCalloutNames';
import generateJSON from '@salesforce/apex/ValidateJSONCreation.generateJSON';
export default class ValidateJSONCreation extends LightningElement {
    value = '';
    options;
    whereClause;
    jsonValue;
    error;

    @wire(getCalloutNames)
    wireCalloutNames({ error, data }) {
        if (data) {
            let poptions = [{ label: '--None--', value: '' }]
            for (let d of data) {
                poptions.push({ label: d, value: d });
                console.log(d)
            }
            this.options = poptions;
            this.value = '';
        } else if (error) {
            alert('Error')
            console.log(error)
        }
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    handleIdInput(event) {
        this.whereClause = ` Id = '${event.detail.value}'`;
    }

    handleWhereCaluse(event) {
        this.whereClause = event.detail.value;
    }

    generateJSON(event) {
        this.error = undefined;
        this.jsonValue = undefined;
        generateJSON({
            calloutName: this.value,
            whereClause: this.whereClause
        })
            .then((result) => {
                this.jsonValue = result;
            }).catch((err) => {
                this.error = err.body.exceptionType + ' => ' + err.body.message + ' => ' + err.body.stackTrace
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: this.error,
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            });
    }
}