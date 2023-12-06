// import { LightningElement } from 'lwc';

// export default class Profile extends LightningElement {}

import { LightningElement, track, wire } from 'lwc';
import updateProfile from'@salesforce/apex/Profile.updateProfile';
import getProfile from '@salesforce/apex/Profile.getProfile';
import { CurrentPageReference } from 'lightning/navigation';
export default class Profile extends LightningElement {
    @track phoneNumber;
    @track dateOfBirth;
    @track tShirt;
    @track shoe;

    @wire(CurrentPageReference)
    currentPageReference;

    get tShirtSize() {
        return [
            { label: 'XS', value: 'XS' },
            { label: 'S', value: 'S' },
            { label: 'M', value: 'M' },
            { label: 'L', value: 'L' },
            { label: 'XL', value: 'XL' },
            { label: 'XXL', value: 'XXL' },
        ];
    }

    get shoeSize() {
        return [
            { label: '6', value: '6' },
            { label: '6.5', value: '6.5' },
            { label: '7', value: '7' },
            { label: '7.5', value: '7.5' },
            { label: '8', value: '8' },
            { label: '8.5', value: '8.5' },
            { label: '9', value: '9' },
            { label: '9.5', value: '9.5' },
            { label: '10', value: '10' },
            { label: '10.5', value: '10.5' },
            { label: '11', value: '11' },
            { label: '11.5', value: '11.5' },
            { label: '12', value: '12' },
            { label: '12.5', value: '12.5' },
            { label: '13', value: '13' },
            { label: '13.5', value: '13.5' },
            { label: '14', value: '14' },
            { label: '14.5', value: '14.5' },
            { label: '15', value: '15' },
            { label: '15.5', value: '15.5' },
            { label: '16', value: '16' }
        ];
    }

    handlePhoneNumberChange(event) {
        this.phoneNumber = event.target.value;
    }

    handleDateOfBirthChange(event) {
        this.dateOfBirth = event.target.value;
    }

    handleTShirtSizeChange(event) {
        this.tShirt = event.target.value;
    }

    handleShoeSizeChange(event) {
        this.shoe = event.target.value;
    }

    

    connectedCallback() {      
        getProfile({ accountId: this.currentPageReference.state.reff})
        .then(result => {
            // Handle success
            console.log('Account 1st Record here', typeof result);
            var data= JSON.parse(result);
            console.log('Account Record here', data);
            this.phoneNumber = data.phoneNumber;
            // Assign this result in the reactive elements
        })
    }

    
    saveUserProfile() {
        // Call the Apex method to save user profile data
        const data = {
            phoneNumber : this.phoneNumber,
            dateOfBirth : this.dateOfBirth,
            tShirtSize : this.tShirt,
            shoeSize: this.shoe,
        };
        updateProfile({ data: JSON.stringify(data)})
            .then(result => {
                // Handle success
                console.log('User profile saved successfully:', result);
            })
            .catch(error => {
                // Handle error
                console.error('Error saving user profile:', error);
            });
    }
}