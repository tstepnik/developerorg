@RestResource(urlMapping = '/v1/utils/*')
 global class MH_UtilsRESTService {

    @HttpGet
    global static List<String> getHospitals() {
        RestRequest request = RestContext.request;
        if (request.requestURI.endsWith('/v1/utils/getCountriesList')) {
            return MH_Utils.getCountriesList();
        }
        return null;
    }
}