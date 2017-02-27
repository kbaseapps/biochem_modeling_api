
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
 * <p>Original spec-file type: DropDownItemRxn</p>
 * 
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "id",
    "name",
    "equation",
    "code",
    "definition",
    "searchnames"
})
public class DropDownItemRxn {

    @JsonProperty("id")
    private String id;
    @JsonProperty("name")
    private String name;
    @JsonProperty("equation")
    private String equation;
    @JsonProperty("code")
    private String code;
    @JsonProperty("definition")
    private String definition;
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

    public DropDownItemRxn withId(String id) {
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

    public DropDownItemRxn withName(String name) {
        this.name = name;
        return this;
    }

    @JsonProperty("equation")
    public String getEquation() {
        return equation;
    }

    @JsonProperty("equation")
    public void setEquation(String equation) {
        this.equation = equation;
    }

    public DropDownItemRxn withEquation(String equation) {
        this.equation = equation;
        return this;
    }

    @JsonProperty("code")
    public String getCode() {
        return code;
    }

    @JsonProperty("code")
    public void setCode(String code) {
        this.code = code;
    }

    public DropDownItemRxn withCode(String code) {
        this.code = code;
        return this;
    }

    @JsonProperty("definition")
    public String getDefinition() {
        return definition;
    }

    @JsonProperty("definition")
    public void setDefinition(String definition) {
        this.definition = definition;
    }

    public DropDownItemRxn withDefinition(String definition) {
        this.definition = definition;
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

    public DropDownItemRxn withSearchnames(String searchnames) {
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
        return ((((((((((((((("DropDownItemRxn"+" [id=")+ id)+", name=")+ name)+", equation=")+ equation)+", code=")+ code)+", definition=")+ definition)+", searchnames=")+ searchnames)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
