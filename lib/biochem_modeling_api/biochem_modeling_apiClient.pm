package biochem_modeling_api::biochem_modeling_apiClient;

use JSON::RPC::Client;
use POSIX;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
my $get_time = sub { time, 0 };
eval {
    require Time::HiRes;
    $get_time = sub { Time::HiRes::gettimeofday() };
};

use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

biochem_modeling_api::biochem_modeling_apiClient

=head1 DESCRIPTION


A KBase module: biochem_modeling_api
This sample module contains one small method - filter_contigs.


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => biochem_modeling_api::biochem_modeling_apiClient::RpcClient->new,
	url => $url,
	headers => [],
    };

    chomp($self->{hostname} = `hostname`);
    $self->{hostname} ||= 'unknown-host';

    #
    # Set up for propagating KBRPC_TAG and KBRPC_METADATA environment variables through
    # to invoked services. If these values are not set, we create a new tag
    # and a metadata field with basic information about the invoking script.
    #
    if ($ENV{KBRPC_TAG})
    {
	$self->{kbrpc_tag} = $ENV{KBRPC_TAG};
    }
    else
    {
	my ($t, $us) = &$get_time();
	$us = sprintf("%06d", $us);
	my $ts = strftime("%Y-%m-%dT%H:%M:%S.${us}Z", gmtime $t);
	$self->{kbrpc_tag} = "C:$0:$self->{hostname}:$$:$ts";
    }
    push(@{$self->{headers}}, 'Kbrpc-Tag', $self->{kbrpc_tag});

    if ($ENV{KBRPC_METADATA})
    {
	$self->{kbrpc_metadata} = $ENV{KBRPC_METADATA};
	push(@{$self->{headers}}, 'Kbrpc-Metadata', $self->{kbrpc_metadata});
    }

    if ($ENV{KBRPC_ERROR_DEST})
    {
	$self->{kbrpc_error_dest} = $ENV{KBRPC_ERROR_DEST};
	push(@{$self->{headers}}, 'Kbrpc-Errordest', $self->{kbrpc_error_dest});
    }

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my $token = Bio::KBase::AuthToken->new(@args);
	
	if (!$token->error_message)
	{
	    $self->{token} = $token->token;
	    $self->{client}->{token} = $token->token;
	}
        else
        {
	    #
	    # All methods in this module require authentication. In this case, if we
	    # don't have a token, we can't continue.
	    #
	    die "Authentication failed: " . $token->error_message;
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




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
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function search_reaction (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to search_reaction:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'search_reaction');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "biochem_modeling_api.search_reaction",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'search_reaction',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method search_reaction",
					    status_line => $self->{client}->status_line,
					    method_name => 'search_reaction',
				       );
    }
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
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function search_compound (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to search_compound:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'search_compound');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "biochem_modeling_api.search_compound",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'search_compound',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method search_compound",
					    status_line => $self->{client}->status_line,
					    method_name => 'search_compound',
				       );
    }
}
 
  
sub status
{
    my($self, @args) = @_;
    if ((my $n = @args) != 0) {
        Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
                                   "Invalid argument count for function status (received $n, expecting 0)");
    }
    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
        method => "biochem_modeling_api.status",
        params => \@args,
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
                           code => $result->content->{error}->{code},
                           method_name => 'status',
                           data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
                          );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method status",
                        status_line => $self->{client}->status_line,
                        method_name => 'status',
                       );
    }
}
   

sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
        method => "biochem_modeling_api.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'search_compound',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method search_compound",
            status_line => $self->{client}->status_line,
            method_name => 'search_compound',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for biochem_modeling_api::biochem_modeling_apiClient\n";
    }
    if ($sMajor == 0) {
        warn "biochem_modeling_api::biochem_modeling_apiClient version is $svr_version. API subject to change.\n";
    }
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

package biochem_modeling_api::biochem_modeling_apiClient::RpcClient;
use base 'JSON::RPC::Client';
use POSIX;
use strict;

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $headers, $obj) = @_;
    my $result;


    {
	if ($uri =~ /\?/) {
	    $result = $self->_get($uri);
	}
	else {
	    Carp::croak "not hashref." unless (ref $obj eq 'HASH');
	    $result = $self->_post($uri, $headers, $obj);
	}

    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $headers, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	@$headers,
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
