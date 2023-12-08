/**
 * @Description: CommutatusIntegration class to do callouts for information to the Commutatus System.
 */
public with sharing class CommutatusIntegration {
    Map<String, String> accountMap;
    public Final String url = 'https://integrations.commutatus.com/webhook/719ce78d-c2c5-47a8-986a-39d7e7a5652d';

    /**
     * @Desciption: setData methood to set the information needed before making the callout to Commutatus
     */
    public CommutatusIntegration setData(List<Account> accounts){
        this.accountMap = new Map<String, String>();
        this.accountMap.put('accId',accounts[0]?.Mask_ID__c);
        this.accountMap.put('email',accounts[0]?.Email__c);
        this.accountMap.put('tshirtSize',accounts[0]?.TShirt_Size__c);
        this.accountMap.put('shoeSize',accounts[0]?.Shoe_Size__c);
        return this;
    }

    /**
     * @Description: Future class to make the callout and update the details on Account.
     */
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