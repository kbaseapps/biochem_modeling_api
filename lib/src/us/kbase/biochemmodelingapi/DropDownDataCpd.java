
package us.kbase.biochemmodelingapi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;


/**
 * <p>Original spec-file type: DropDownDataCpd</p>
 * 
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "num_of_hits",
    "hits"
})
public class DropDownDataCpd {

    @JsonProperty("num_of_hits")
    private Long numOfHits;
    @JsonProperty("hits")
    private List<DropDownItemCpd> hits;
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    @JsonProperty("num_of_hits")
    public Long getNumOfHits() {
        return numOfHits;
    }

    @JsonProperty("num_of_hits")
    public void setNumOfHits(Long numOfHits) {
        this.numOfHits = numOfHits;
    }

    public DropDownDataCpd withNumOfHits(Long numOfHits) {
        this.numOfHits = numOfHits;
        return this;
    }

    @JsonProperty("hits")
    public List<DropDownItemCpd> getHits() {
        return hits;
    }

    @JsonProperty("hits")
    public void setHits(List<DropDownItemCpd> hits) {
        this.hits = hits;
    }

    public DropDownDataCpd withHits(List<DropDownItemCpd> hits) {
        this.hits = hits;
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
        return ((((((("DropDownDataCpd"+" [numOfHits=")+ numOfHits)+", hits=")+ hits)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
