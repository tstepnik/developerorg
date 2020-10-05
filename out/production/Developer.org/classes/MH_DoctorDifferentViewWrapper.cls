/**
 * Created by tomas on 04.10.2020.
 */

public with sharing class MH_DoctorDifferentViewWrapper {
    String id { get; set; }
    String firstName { get; set; }
    String lastName { get; set; }
    String email { get; set; }
    String country { get; set; }
    String town { get; set; }
    String birthdate { get; set; }
    String licenceNumber { get; set; }

    public MH_DoctorDifferentViewWrapper(String id, String firstName, String lastName, String email, String country, String town, String birthdate, String licenceNumber){

    }
}