public with sharing class CryptoReturn {
    @InvocableMethod(label='MD5' description='Return MD5 Crypto')
    public static List<String> getMD5Crypto(List<SObject> inst) {
        Blob targetBlob = Blob.valueOf(inst[0]?.Id);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        return new String[]{EncodingUtil.base64Encode(hash).substring(0,22)};
    }
}