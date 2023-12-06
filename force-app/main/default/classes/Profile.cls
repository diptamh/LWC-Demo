public without sharing class Profile {
    @AuraEnabled(cacheable=true)
    public static string getProfile(String accountId){
        try {
            List<Account> accounts = [SELECT Phone FROM Account WHERE Id=: accountId LIMIT 1];
            String parsed= new Profile.Parser(accounts[0]).returnString;
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

        Parser returnParser;
        String returnString;
        
        public Parser(){}
        public Parser(String data){
            returnParser = (parser) JSON.deserialize(data, Profile.Parser.class);
        }

        public Parser(Account account){
            Profile.Parser instance = new Parser();
            instance.phoneNumber = account.Phone;
            returnString = (String) JSON.serialize(instance);
        }
    }
}