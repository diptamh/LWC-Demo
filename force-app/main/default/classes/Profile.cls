/**
 * @Description: Profile class to interact with the LWC component at FE to Get and Update Account Details.
 */
public without sharing class Profile {

    /**
     * @Description: Method to get the Account Details and return Account's data in string format.
     */
    @AuraEnabled(cacheable=true)
    public static string getProfile(String accountId){
        try {
            List<Account> accounts = [  SELECT  Phone,
                                                Date_Of_Birth__c,
                                                Shoe_Size__c,
                                                TShirt_Size__c,
                                                Mask_ID__c
                                        FROM    Account 
                                        WHERE   Mask_ID__c=: accountId 
                                        AND     Profile_Completed__c = FALSE 
                                        LIMIT 1 ];
            System.debug('accounts-->'+accountId);
            String parsed= new Profile.Parser(accounts[0])?.returnString;
            return parsed;
        } catch (Exception e) {
            System.debug('Error');
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @Description: Method to update the Account Details and return true when Done
     */
    @AuraEnabled(cacheable=false)
    public static string updateProfile(String data){
        try {
            Profile.Parser parsed= new Parser(data).returnParser;
            System.debug('parsed--->'+parsed);
            List<Account> accounts =[   SELECT  Mask_ID__c,
                                                Phone,
                                                Email__c,
                                                Date_Of_Birth__c,
                                                Shoe_Size__c,
                                                TShirt_Size__c,
                                                Profile_Completed__c 
                                        FROM    Account 
                                        WHERE   Mask_ID__c =: parsed != null ? parsed.accountId : null
                                        AND     Profile_Completed__c = FALSE];

            accounts[0].Profile_Completed__c = true;
            accounts[0].Phone = parsed?.phoneNumber;
            accounts[0].Date_Of_Birth__c = parsed?.dateOfBirth;
            accounts[0].Shoe_Size__c = parsed?.shoeSize;
            accounts[0].TShirt_Size__c = parsed?.tShirtSize;
            Database.upsert(accounts);
            new CommutatusIntegration().setData(accounts);
            return 'ac';
        } catch (Exception e) {
            System.debug('Error');
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @Description: Data parser class to parse data from Object to JSON and vice versa.
     */
    public without sharing class Parser {
        public String phoneNumber;
        public Date dateOfBirth;
        public String tShirtSize;
        public String shoeSize;
        public String accountId;

        Parser returnParser;
        String returnString;
        
        public Parser(){}
        public Parser(String data){
            returnParser = (parser) JSON.deserialize(data, Profile.Parser.class);
        }

        public Parser(Account account){
            Profile.Parser instance = new Parser();
            instance.phoneNumber = account?.Phone;
            instance.dateOfBirth = account?.Date_Of_Birth__c;
            instance.shoeSize = account?.Shoe_Size__c;
            instance.tShirtSize = account?.TShirt_Size__c;
            returnString = (String) JSON.serialize(instance);
        }
    }
}