import { LightningElement, track, wire } from 'lwc';
import updateProfile from'@salesforce/apex/Profile.updateProfile';
import getProfile from '@salesforce/apex/Profile.getProfile';
import { CurrentPageReference } from 'lightning/navigation';
export default class Profile extends LightningElement {
    @track phoneNumber;
    @track dateOfBirth;
    @track tShirt;
    @track shoe;
    @track message = '';
    @track messageClass = ''; 

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
        console.log('reff',this.currentPageReference.state.reff);  
        getProfile({ accountId: this.currentPageReference.state.reff})
        .then(result => {
            var data= JSON.parse(result);
            this.phoneNumber = data.phoneNumber;
            this.dateOfBirth = data.dateOfBirth;
            this.tShirt = data.tShirtSize;
            this.shoe = data.shoeSize;
        }).catch(error => {
            // Handle error
            this.message = saveSuccessful ? 'Something went wrong.' : 'Something went wrong.';
            this.messageClass = saveSuccessful ? 'success' : 'error';
            console.error('Error saving user profile:', error);
        });
    }

    
    saveUserProfile() {
        // Call the Apex method to save user profile data
        const saveSuccessful = true;

        // Update message and class based on save result
        const data = {
            phoneNumber : this.phoneNumber,
            dateOfBirth : this.dateOfBirth,
            tShirtSize : this.tShirt,
            shoeSize: this.shoe,
            accountId: this.currentPageReference.state.reff,
        };
        updateProfile({ data: JSON.stringify(data)})
            .then(result => {
                // Handle success
                this.message = saveSuccessful ? 'Data saved successfully.' : result;
                this.messageClass = saveSuccessful ? 'success' : 'error';
                console.log('User profile saved successfully:', 'Record already updated');
            })
            .catch(error => {
                // Handle error
                this.message = saveSuccessful ? 'Something went wrong.' : 'Something went wrong.';
                this.messageClass = saveSuccessful ? 'success' : 'error';
                console.error('Error saving user profile:', error);
            });
    }
}