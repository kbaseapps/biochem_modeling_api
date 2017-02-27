use biochem_modeling_api::biochem_modeling_apiImpl;

use biochem_modeling_api::biochem_modeling_apiServer;
use Plack::Middleware::CrossOrigin;



my @dispatch;

{
    my $obj = biochem_modeling_api::biochem_modeling_apiImpl->new;
    push(@dispatch, 'biochem_modeling_api' => $obj);
}


my $server = biochem_modeling_api::biochem_modeling_apiServer->new(instance_dispatch => { @dispatch },
				allow_get => 0,
			       );

my $handler = sub { $server->handle_input(@_) };

$handler = Plack::Middleware::CrossOrigin->wrap( $handler, origins => "*", headers => "*");
