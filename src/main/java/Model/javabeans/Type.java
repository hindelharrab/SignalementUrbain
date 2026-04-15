package Model.javabeans;

public class Type {
    private int idType;
    private String nomType;

    public Type() {}

    public Type(int idType, String nomType) {
        this.idType = idType;
        this.nomType = nomType;
    }

    public int getIdType() { return idType; }
    public void setIdType(int idType) { this.idType = idType; }

    public String getNomType() { return nomType; }
    public void setNomType(String nomType) { this.nomType = nomType; }
}
