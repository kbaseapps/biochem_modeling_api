/*
A KBase module: biochem_modeling_api
This sample module contains one small method - filter_contigs.
*/

module biochem_modeling_api {
    /*
        A string representing a ContigSet id.
    */
    typedef string contigset_id;


    typedef structure {
        string search;
        int limit;
        int start;
    }DropDownItemInputParams;

    typedef structure {
        string id;
        string name;
        string equation;
        string code;
        string definition;
        string searchnames;
    } DropDownItemRxn;

    typedef structure{
        int num_of_hits;
        list<DropDownItemRxn> hits;
    } DropDownDataRxn;

    funcdef search_reaction (DropDownItemInputParams params) returns (DropDownDataRxn output) authentication required;


    typedef structure {
        string id;
        string name;
        string formula;
        string abr;
        string searchnames;
    } DropDownItemCpd;

    typedef structure{
        int num_of_hits;
        list<DropDownItemCpd> hits;
    } DropDownDataCpd;

    funcdef search_compound (DropDownItemInputParams params) returns (DropDownDataCpd output) authentication required;

};
