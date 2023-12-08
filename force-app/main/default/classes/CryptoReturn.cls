/**
 * @Desciption: Crypto Class to return random random geenrated Id for SF Id masking.
 */
public with sharing class CryptoReturn {
    /**
     * @Description: Invocable Class to facilitate the random Id generation from Flows and Process builders.
     */
    @InvocableMethod(label='MD5' description='Return MD5 Crypto')
    public static List<String> getMD5Crypto(List<SObject> inst) {
        Blob targetBlob = Blob.valueOf(inst[0]?.Id);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        return new String[]{EncodingUtil.base64Encode(hash).substring(0,22)};
    }
}