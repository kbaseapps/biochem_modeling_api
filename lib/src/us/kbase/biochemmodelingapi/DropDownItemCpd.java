
package us.kbase.biochemmodelingapi;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: DropDownItemCpd</p>
 * 
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "id",
    "name",
    "formula",
    "abr",
    "searchnames"
})
public class DropDownItemCpd {

    @JsonProperty("id")
    private String id;
    @JsonProperty("name")
    private String name;
    @JsonProperty("formula")
    private String formula;
    @JsonProperty("abr")
    private String abr;
    @JsonProperty("searchnames")
    private String searchnames;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("id")
    public String getId() {
        return id;
    }

    @JsonProperty("id")
    public void setId(String id) {
        this.id = id;
    }

    public DropDownItemCpd withId(String id) {
        this.id = id;
        return this;
    }

    @JsonProperty("name")
    public String getName() {
        return name;
    }

    @JsonProperty("name")
    public void setName(String name) {
        this.name = name;
    }

    public DropDownItemCpd withName(String name) {
        this.name = name;
        return this;
    }

    @JsonProperty("formula")
    public String getFormula() {
        return formula;
    }

    @JsonProperty("formula")
    public void setFormula(String formula) {
        this.formula = formula;
    }

    public DropDownItemCpd withFormula(String formula) {
        this.formula = formula;
        return this;
    }

    @JsonProperty("abr")
    public String getAbr() {
        return abr;
    }

    @JsonProperty("abr")
    public void setAbr(String abr) {
        this.abr = abr;
    }

    public DropDownItemCpd withAbr(String abr) {
        this.abr = abr;
        return this;
    }

    @JsonProperty("searchnames")
    public String getSearchnames() {
        return searchnames;
    }

    @JsonProperty("searchnames")
    public void setSearchnames(String searchnames) {
        this.searchnames = searchnames;
    }

    public DropDownItemCpd withSearchnames(String searchnames) {
        this.searchnames = searchnames;
        return this;
    }

    @JsonAnyGetter
    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public String toString() {
        return ((((((((((((("DropDownItemCpd"+" [id=")+ id)+", name=")+ name)+", formula=")+ formula)+", abr=")+ abr)+", searchnames=")+ searchnames)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
