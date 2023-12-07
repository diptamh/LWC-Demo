public without sharing class Profile {
    @AuraEnabled(cacheable=true)
    public static string getProfile(String accountId){
        try {
            List<Account> accounts = [  SELECT  Phone,
                                                PersonBirthdate,
                                                Shoe_Size__c,
                                                TShirt_Size__c,
                                                Masked_Id__c
                                        FROM    Account 
                                        WHERE   Masked_Id__c=: accountId 
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

    @AuraEnabled(cacheable=true)
    public static string updateProfile(String data){
        try {
            Profile.Parser parsed= new Parser(data).returnParser;
            Account acc = new Account(  Masked_Id__c = parsed.accountId,
                                        Phone = parsed.phoneNumber,
                                        PersonBirthdate = parsed.dateOfBirth,
                                        Shoe_Size__c = parsed.shoeSize,
                                        TShirt_Size__c = parsed.tShirtSize);
            Database.upsert(acc);
            CommutatusIntegration.setData(parsed.accountId);
            return 'ac';
        } catch (Exception e) {
            System.debug('Error');
            throw new AuraHandledException(e.getMessage());
        }
    }

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
            instance.dateOfBirth = account?.PersonBirthdate;
            instance.shoeSize = account?.Shoe_Size__c;
            instance.tShirtSize = account?.TShirt_Size__c;
            returnString = (String) JSON.serialize(instance);
        }
    }
}