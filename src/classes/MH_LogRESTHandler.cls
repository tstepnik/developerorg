public with sharing class MH_LogRESTHandler {
    private final String clientId;
    private final String clientSecret;
    private final String username;
    private final String password;
    private final String prefix;
    private final String mainEndpoint;
    private final String countriesEndpoint;
    private final String authEndpoint;
    private final String contentType;
    private Boolean invalidSession;
    public String token { get; set; }
    private Cache.SessionPartition sessionPartition;
    private MH_LogExternalApi tokenLog;
    private Boolean tokenLogInserted;
    private static MH_LogRESTHandler logHandler;

    public MH_LogRESTHandler() {
        clientId = '3MVG9lsAlIP.W_V8rWdiEcd0vNgygC.FZPnwSnBJ0AmTpltAZUhcdTJ5Qd91kArlmTxVK90cB0VUIHSujnX_6';
        clientSecret = '7A9C14D769189D762E356C0A9FA24A38C2466A898564BCC14154769FD24AC0EC';
        username = 'tomasz.stepnik77@britenet.com.pl';
        password = 'tomek123TcmlQuvpeiEnOhMpZ6pdXo9zL';
        prefix = MH_Utils.getConfigurationsValue('MH_HospitalRestEndpointPrefix');
        mainEndpoint = prefix + '/services/apexrest/v1/logs/';
        contentType = MH_Utils.getConfigurationsValue('MH_HospitalRestContentType');

        authEndpoint = prefix + MH_Utils.getConfigurationsValue('MH_HospitalRestOAuthEndpoint') + clientId + '&username=' + username +
                '&password=' + password + '&client_secret=' + clientSecret;
        token = getAccessToken();
    }

    public static MH_LogRESTHandler getLogHandler() {
        if (logHandler == null) {
            return new MH_LogRESTHandler();
        } else {
            return logHandler;
        }
    }


    public String getAccessToken() {
        HttpResponse responseFromHX = new HttpResponse();
        HttpRequest requestToHX = new HttpRequest();
        requestToHX.setMethod('POST');
        requestToHX.setEndpoint(authEndpoint);
        responseFromHX = new Http().send(requestToHX);
        hadnleAuthentication(responseFromHX);

        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(responseFromHX.getBody());
        return (String) jsonMap.get('access_token');
    }
    private void hadnleAuthentication(HttpResponse response) {
        Integer statusCode = response.getStatusCode();
        String body = response.getBody();
        if (statusCode == 400 && body.contains('invalid_grant')) {
            throw new MH_InvalidCredentialsException('Cannot log to external service. Please check your credentials.Page could invoke another exceptions, please do not use it until exception disappears.');
        } else if (statusCode != 200) {
            throw new MH_ExternalServiceConnetionException('There is a problem with connet to external service.');
        }
    }

    public void addLog(Map<String,Object> logMap){
        System.debug('WCHODZI DO ADDLOG HANDLERA');
        System.debug('WCHODZI DO ADDLOG HANDLERA');
        System.debug('WCHODZI DO ADDLOG HANDLERA');
        String accessToken = 'OAuth ' + token;
        HttpRequest request = new HttpRequest();
        HttpResponse response;
        request.setEndpoint(mainEndpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', accessToken);
        request.setHeader('Content-Type', contentType);
        request.setBody(JSON.serialize(logMap));
        response = new Http().send(request);
        System.debug(request.getBody());
        System.debug(response.getBody());
    }

}


















