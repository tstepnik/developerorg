@RestResource(urlMapping = '/v1/*')
 global class MH_UtilsRESTService {

    @HttpGet
    global static List<String> getHospitals() {
        RestRequest request = RestContext.request;
        if (request.requestURI.endsWith('/v1/countries')) {
            return MH_Utils.getCountriesList();
        }
        return null;
    }
}