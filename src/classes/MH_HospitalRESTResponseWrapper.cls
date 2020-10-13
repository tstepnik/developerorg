global class MH_HospitalRESTResponseWrapper {

    public String id { get; set; }
    public String name { get; set; }
    public String country { get; set; }
    public String town { get; set; }
    public String street { get; set; }
    public String email { get; set; }
    public String externalId { get; set; }

    public MH_HospitalRESTResponseWrapper() {
    }
    public MH_HospitalRESTResponseWrapper(String id, String externalId, String name, String country, String town, String street, String email) {
        this.id = id;
        this.externalId = externalId;
        this.name = name;
        this.country = country;
        this.town = town;
        this.street = street;
    }

    public MH_HospitalRESTResponseWrapper(String externalId, String name, String country, String town, String street, String email) {
        this.externalId = externalId;
        this.name = name;
        this.country = country;
        this.town = town;
        this.street = street;
        this.email = email;
    }

}