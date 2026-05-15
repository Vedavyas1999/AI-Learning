public class URLUtil {
    public static String getSalesforceBaseUrl() {
        return URL.getOrgDomainUrl().toExternalForm();
    }
}