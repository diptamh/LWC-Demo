public with sharing class CommutatusIntegration {
    Map<String, String> accountMap;
    public Final String url = 'https://integrations.commutatus.com/webhook/719ce78d-c2c5-47a8-986a-39d7e7a5652d';
    public CommutatusIntegration setData(String maskedID){
        List<Account> accounts= [Select Id,PersonEmail,Shoe_Size__c,TShirt_Size__c from Account where Masked_Id__c =: maskedID];

        this.accountMap = new Map<String, String>();
        this.accountMap.put('accId',accounts[0]?.ID);
        this.accountMap.put('email',accounts[0]?.PersonEmail);
        this.accountMap.put('tshirtSize',accounts[0]?.TShirt_Size__c);
        this.accountMap.put('shoeSize',accounts[0]?.Shoe_Size__c);
        return this;
    }
    @future(callout=true)
    public static void callingCommutatus(Map<String, String> accountMap){
        HTTPCallout http = new  HTTPCallout()
                                .setEndpoint('url')
                                .setMethod('POST')
                                .setBody(String.valueOf(accountMap))
                                .send();

        if(http.getStatus() == '200'){
            upsert new Account(Id = accountMap.get('accId'),Description= ((Map<String,String>)JSON.deserialize(http.getBody(), Map<String,String>.class)).get('customer_id'));
        }

    }

}