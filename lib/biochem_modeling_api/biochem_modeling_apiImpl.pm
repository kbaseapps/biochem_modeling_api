package biochem_modeling_api::biochem_modeling_apiImpl;
use strict;
use Bio::KBase::Exceptions;
# Use Semantic Versioning (2.0.0-rc.1)
# http://semver.org
our $VERSION = '0.0.1';
our $GIT_URL = '';
our $GIT_COMMIT_HASH = '';

=head1 NAME

biochem_modeling_api

=head1 DESCRIPTION

A KBase module: biochem_modeling_api
This sample module contains one small method - filter_contigs.

=cut

#BEGIN_HEADER
use Bio::KBase::AuthToken;
use Workspace::WorkspaceClient;
use Config::IniFiles;
use Data::Dumper;
use POSIX;
use FindBin qw($Bin);
use JSON;
use LWP::UserAgent;
use Try::Tiny;
use XML::Simple;
use Cache::MemoryCache;




sub search_solr
{
    my ($solr_core, $solrurl, $search, $start, $limit, $id, $asc, $method) = @_;
    #print "$solr_core\t $solrurl\t $search\t $start\t$limit\t$method\n";
    my $url = $solrurl."/$solr_core/select?q=*$search*%0A&sort=$asc+asc&start=$start&rows=$limit&fl=id%2Ccode%2Cname%2Cdefinition%2Cequation%2Cnames%2Csearchnames&df=$id&wt=json&indent=true";
    #my $url = $solrurl."/$solr_core/select?q=rxn270*%0A&sort=id+asc&start=0&rows=100&fl=id%2Ccode%2Cname%2Cdefinition%2Cequation%2Cnames%2Csearchnames&df=id&wt=json&indent=true";
    print $url ."\n";
    my $method = 'GET';
    my $jsonf = solr_request ($method, $url);
    return $jsonf;
}

sub searchname
{
    my $sn = $_[0];
    $sn =~ s/^\s+//;
    $sn =~ s/_//g;
    $sn =~ s/-//g;
    $sn =~ s/,//g;
    $sn =~ tr/A-Z/a-z/;
    $sn =~ s/[\s]//g;
    $sn =~ s/(?<=\(ec)[^)]+[^(]+(?=\))//g;
    $sn =~ s/(?<=\(tc)[^)]+[^(]+(?=\))//g;
    return $sn;
}

sub solr_request
{

    my ($method, $url) = @_;
    # create a HTTP request
    try {
        my $ua = LWP::UserAgent->new();
        my $request = HTTP::Request->new();
        $request->method($method);
        $request->uri($url);

        my $response = $ua->request($request);
        my $sn = $response->content();
        my $code = $response->code();
        my $jsonf = JSON::from_json($sn);

        return $jsonf;
    }catch {
    # Print out the exception that occurred
    warn "SOLR request return code 403, caught error: $_";
    die;
    }

}
#END_HEADER

sub new
{
    my($class, @args) = @_;
    my $self = {
    };
    bless $self, $class;
    #BEGIN_CONSTRUCTOR

    my $config_file = $ENV{ KB_DEPLOYMENT_CONFIG };
    my $cfg = Config::IniFiles->new(-file=>$config_file);
    my $wsInstance = $cfg->val('biochem_modeling_api','workspace-url');
    die "no workspace-url defined" unless $wsInstance;

    $self->{'workspace-url'} = $wsInstance;
    #SOLR specific parameters
    if (! $self->{_SOLR_URL}) {
        $self->{_SOLR_URL} = "http://kbase.us/internal/solr-ci/search";
        #$self->{_SOLR_URL} = "localhost:8005/search";
    }
    $self->{_SOLR_POST_URL} = $self->{_SOLR_URL};
    $self->{_SOLR_PING_URL} = "$self->{_SOLR_URL}/select";
    $self->{_AUTOCOMMIT} = 0;
    $self->{_CT_XML} = { Content_Type => 'text/xml; charset=utf-8' };
    $self->{_CT_JSON} = { Content_Type => 'text/json'};


    #END_CONSTRUCTOR

    if ($self->can('_init_instance'))
    {
	$self->_init_instance();
    }
    return $self;
}

=head1 METHODS



=head2 search_reaction

  $output = $obj->search_reaction($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a biochem_modeling_api.DropDownItemInputParams
$output is a biochem_modeling_api.DropDownDataRxn
DropDownItemInputParams is a reference to a hash where the following keys are defined:
	search has a value which is a string
	limit has a value which is an int
	start has a value which is an int
DropDownDataRxn is a reference to a hash where the following keys are defined:
	num_of_hits has a value which is an int
	hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemRxn
DropDownItemRxn is a reference to a hash where the following keys are defined:
	id has a value which is a string
	name has a value which is a string
	equation has a value which is a string
	code has a value which is a string
	definition has a value which is a string
	searchnames has a value which is a string

</pre>

=end html

=begin text

$params is a biochem_modeling_api.DropDownItemInputParams
$output is a biochem_modeling_api.DropDownDataRxn
DropDownItemInputParams is a reference to a hash where the following keys are defined:
	search has a value which is a string
	limit has a value which is an int
	start has a value which is an int
DropDownDataRxn is a reference to a hash where the following keys are defined:
	num_of_hits has a value which is an int
	hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemRxn
DropDownItemRxn is a reference to a hash where the following keys are defined:
	id has a value which is a string
	name has a value which is a string
	equation has a value which is a string
	code has a value which is a string
	definition has a value which is a string
	searchnames has a value which is a string


=end text



=item Description



=back

=cut

sub search_reaction
{
    my $self = shift;
    my($params) = @_;

    my @_bad_arguments;
    (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"params\" (value was \"$params\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to search_reaction:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'search_reaction');
    }

    my $ctx = $biochem_modeling_api::biochem_modeling_apiServer::CallContext;
    my($output);
    #BEGIN search_reaction
    my $solr_core = "Reactions";
    my $solrurl = $self->{_SOLR_URL};
    my $method = 'GET';
    my $hits_list = [];
    my $search_response->{response}->{numFound} = 0;
    my $search_response_name->{response}->{numFound} = 0;
    print &Dumper ($params);
    eval{
        if (defined $params->{search}){
            my $search_field = "id";
            my $asc = "id";
            $search_response = search_solr($solr_core, $solrurl, $params->{search}, $params->{start}, $params->{limit}, $search_field, $asc, $method);
            $hits_list = $search_response->{response}->{docs};
            print length($search_response->{response}->{docs})."first run $search_response->{response}->{numFound}\n";

            #my $search_field = "text";
            my $search_field = "searchnames";
            my $searchword = searchname($params->{search});
            my $asc = "name";
            #$search_response_name = search_solr($solr_core, $solrurl, $params->{search}, $params->{start}, $params->{limit}, $search_field, $asc, $method);
            $search_response_name = search_solr($solr_core, $solrurl, $searchword, $params->{start}, $params->{limit}, $search_field, $asc, $method);

            push @$hits_list, $_ foreach $search_response_name->{response}->{docs};
        }


    };
    if ($@){
      print "Exception message: " . $@->{"message"} . "\n";
      print "JSONRPC code: " . $@->{"code"} . "\n";
      print "Method: " . $@->{"method_name"} . "\n";
      print "Client-side exception:\n";
      print $@;
      print "Server-side exception:\n";
      print $@->{"data"};
      die $@;
    }

        $output = {
            hits => $hits_list,
            num_of_hits =>  ($search_response->{response}->{numFound} + $search_response_name->{response}->{numFound})
        };

        print &Dumper ($output);
    #END search_reaction
    my @_bad_returns;
    (ref($output) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"output\" (value was \"$output\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to search_reaction:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'search_reaction');
    }
    return($output);
}




=head2 search_compound

  $output = $obj->search_compound($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a biochem_modeling_api.DropDownItemInputParams
$output is a biochem_modeling_api.DropDownDataCpd
DropDownItemInputParams is a reference to a hash where the following keys are defined:
	search has a value which is a string
	limit has a value which is an int
	start has a value which is an int
DropDownDataCpd is a reference to a hash where the following keys are defined:
	num_of_hits has a value which is an int
	hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemCpd
DropDownItemCpd is a reference to a hash where the following keys are defined:
	id has a value which is a string
	name has a value which is a string
	formula has a value which is a string
	abr has a value which is a string
	searchnames has a value which is a string

</pre>

=end html

=begin text

$params is a biochem_modeling_api.DropDownItemInputParams
$output is a biochem_modeling_api.DropDownDataCpd
DropDownItemInputParams is a reference to a hash where the following keys are defined:
	search has a value which is a string
	limit has a value which is an int
	start has a value which is an int
DropDownDataCpd is a reference to a hash where the following keys are defined:
	num_of_hits has a value which is an int
	hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemCpd
DropDownItemCpd is a reference to a hash where the following keys are defined:
	id has a value which is a string
	name has a value which is a string
	formula has a value which is a string
	abr has a value which is a string
	searchnames has a value which is a string


=end text



=item Description



=back

=cut

sub search_compound
{
    my $self = shift;
    my($params) = @_;

    my @_bad_arguments;
    (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"params\" (value was \"$params\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to search_compound:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'search_compound');
    }

    my $ctx = $biochem_modeling_api::biochem_modeling_apiServer::CallContext;
    my($output);
    #BEGIN search_compound
    my $solr_core = "Compounds";
    my $solrurl = $self->{_SOLR_URL};
    my $method = 'GET';
    my $hits_list = [];
    my $search_response->{response}->{numFound} = 0;
    my $search_response_name->{response}->{numFound} = 0;
    print &Dumper ($params);
    eval{
        if (defined $params->{search}){


            my $search_field = "id";
            my $asc = "id";
            $search_response = search_solr($solr_core, $solrurl, searchname($params->{search}), $params->{start}, $params->{limit}, $search_field, $asc, $method);
            $hits_list = $search_response->{response}->{docs};

            print &Dumper ($hits_list);
            #my $search_field = "text";
            my $search_field = "searchnames";
            my $asc = "name";
            my $searchword = searchname($params->{search});
             #$search_response_name = search_solr($solr_core, $solrurl, $params->{search}, $params->{start}, $params->{limit}, $search_field, $asc, $method);
             print "$searchword\n";

             $search_response_name = search_solr($solr_core, $solrurl, $searchword, $params->{start}, $params->{limit}, $search_field, $asc, $method);

            push @$hits_list, $_ foreach $search_response_name->{response}->{docs};

            print &Dumper ($hits_list);



        }
    };

    if ($@){
      print "Exception message: " . $@->{"message"} . "\n";
      print "JSONRPC code: " . $@->{"code"} . "\n";
      print "Method: " . $@->{"method_name"} . "\n";
      print "Client-side exception:\n";
      print $@;
      print "Server-side exception:\n";
      print $@->{"data"};
      die $@;
    }



        $output = {
            hits => $hits_list,
            num_of_hits =>  ($search_response->{response}->{numFound} + $search_response_name->{response}->{numFound})
        };

    #print &Dumper ($output);

    #END search_compound
    my @_bad_returns;
    (ref($output) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"output\" (value was \"$output\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to search_compound:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'search_compound');
    }
    return($output);
}




=head2 status

  $return = $obj->status()

=over 4

=item Parameter and return types

=begin html

<pre>
$return is a string
</pre>

=end html

=begin text

$return is a string

=end text

=item Description

Return the module status. This is a structure including Semantic Versioning number, state and git info.

=back

=cut

sub status {
    my($return);
    #BEGIN_STATUS
    $return = {"state" => "OK", "message" => "", "version" => $VERSION,
               "git_url" => $GIT_URL, "git_commit_hash" => $GIT_COMMIT_HASH};
    #END_STATUS
    return($return);
}

=head1 TYPES



=head2 contigset_id

=over 4



=item Description

A string representing a ContigSet id.


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 DropDownItemInputParams

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
search has a value which is a string
limit has a value which is an int
start has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
search has a value which is a string
limit has a value which is an int
start has a value which is an int


=end text

=back



=head2 DropDownItemRxn

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
name has a value which is a string
equation has a value which is a string
code has a value which is a string
definition has a value which is a string
searchnames has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
name has a value which is a string
equation has a value which is a string
code has a value which is a string
definition has a value which is a string
searchnames has a value which is a string


=end text

=back



=head2 DropDownDataRxn

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
num_of_hits has a value which is an int
hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemRxn

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
num_of_hits has a value which is an int
hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemRxn


=end text

=back



=head2 DropDownItemCpd

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is a string
name has a value which is a string
formula has a value which is a string
abr has a value which is a string
searchnames has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is a string
name has a value which is a string
formula has a value which is a string
abr has a value which is a string
searchnames has a value which is a string


=end text

=back



=head2 DropDownDataCpd

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
num_of_hits has a value which is an int
hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemCpd

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
num_of_hits has a value which is an int
hits has a value which is a reference to a list where each element is a biochem_modeling_api.DropDownItemCpd


=end text

=back



=cut

1;
