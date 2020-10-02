/**
 * Created by BRITENET on 02.10.2020.
 */

public with sharing class MH_SoapHandler {

    public soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebService soapWebService { get; set; }
    public soapSforceComSchemasClassHcsDoctor.SessionHeader_element header { get; set; }
    public String credentials { get; set; }

    public MH_SoapHandler( String credentials){
        soapWebService = new soapSforceComSchemasClassHcsDoctor.HCS_DoctorsWebService();
        header = new soapSforceComSchemasClassHcsDoctor.SessionHeader_element();
        this.credentials = credentials;
//        header.sessionId = soapWebService.getAccessTokenToEndpoint(credentials);
        soapWebService.SessionHeader = header;
    }



}