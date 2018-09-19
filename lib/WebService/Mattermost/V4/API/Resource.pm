package WebService::Mattermost::V4::API::Resource;

use DDP;
use List::MoreUtils 'all';
use Moo;
use Types::Standard qw(HashRef Str);

use WebService::Mattermost::V4::API::Request;
use WebService::Mattermost::V4::API::Response;
use WebService::Mattermost::Helper::Alias qw(v4 view);
use WebService::Mattermost::V4::API::Object::Channel;
use WebService::Mattermost::V4::API::Object::User;

with qw(
    WebService::Mattermost::V4::API::Role::RequireID
    WebService::Mattermost::Role::UserAgent
);

################################################################################

has base_url   => (is => 'ro', isa => Str, required => 1);
has resource   => (is => 'ro', isa => Str, required => 1);
has auth_token => (is => 'rw', isa => Str, required => 1);

has delete  => (is => 'ro', isa => Str,     default => 'DELETE');
has get     => (is => 'ro', isa => Str,     default => 'GET');
has headers => (is => 'ro', isa => HashRef, default => sub { {} });
has post    => (is => 'ro', isa => Str,     default => 'POST');
has put     => (is => 'ro', isa => Str,     default => 'PUT');

################################################################################

sub _delete {
    my $self = shift;
    my $args = shift;

    $args->{method} = $self->delete;

    return $self->_call($args);
}

sub _single_view_delete {
    my $self = shift;
    my $args = shift;

    $args->{single} = 1;

    return $self->_delete($args);
}

sub _get {
    my $self = shift;
    my $args = shift;

    $args->{method} = $self->get;

    return $self->_call($args);
}

sub _single_view_get {
    my $self = shift;
    my $args = shift;

    $args->{single} = 1;

    return $self->_get($args);
}

sub _post {
    my $self = shift;
    my $args = shift;

    $args->{method} = $self->post;

    return $self->_call($args);
}

sub _single_view_post {
    my $self = shift;
    my $args = shift;

    $args->{single} = 1;

    return $self->_post($args);
}

sub _put {
    my $self = shift;
    my $args = shift;

    $args->{method} = $self->put;

    return $self->_call($args);
}

sub _single_view_put {
    my $self = shift;
    my $args = shift;

    $args->{method} = $self->put;

    return $self->_put($args);
}

sub _call {
    my $self = shift;
    my $args = shift;

    if ($args->{required}) {
        my $validation = $self->_validate($args->{parameters}, $args->{required});

        return $validation unless $validation->{valid};
    }

    my %headers = ('Keep-Alive' => 1);

    if ($self->auth_token) {
        $headers{Cookie}        = $self->mmauthtoken($self->auth_token);
        $headers{Authorization} = $self->bearer($self->auth_token);
    }

    my $request = $self->_as_request($args);
    my $method  = lc $request->method;

    my $form_type;

    if (grep { $_ eq $request->method } ($self->put, $self->post)) {
        $form_type = 'json';
    } else {
        $form_type = 'form';
    }

    $form_type = $args->{override_data_type} if $args->{override_data_type};

    my $tx = $self->ua->$method(
        $request->url => \%headers,
        $form_type    => $request->parameters,
    );

    return $self->_as_response($tx->res, $args);
}

sub _as_request {
    my $self = shift;
    my $args = shift;

    $args->{auth_token} = $self->auth_token;
    $args->{base_url}   = $self->base_url;
    $args->{resource}   = $self->resource;

    $args->{endpoint}   ||= '';
    $args->{parameters} ||= {};

    return WebService::Mattermost::V4::API::Request->new($args);
}

sub _as_response {
    my $self = shift;
    my $res  = shift;
    my $args = shift;

    return WebService::Mattermost::V4::API::Response->new({
        auth_token  => $self->auth_token,
        base_url    => $self->base_url,
        code        => $res->code,
        headers     => $res->headers,
        is_error    => $res->is_error   ? 1 : 0,
        is_success  => $res->is_success ? 1 : 0,
        message     => $res->message,
        prev        => $res,
        raw_content => $res->body,
        item_view   => $args->{view},
        single_item => $args->{single},
    });
}

sub _validate {
    my $self     = shift;
    my $args     = shift;
    my $required = shift;

    # Grab a slice of the keys from given arguments
    my %slice = %{$args}{@{$required}};

    return { valid => 1 } if all { defined($_) } values %slice;

    my @missing;

    foreach my $kx (@{$required}) {
        push @missing, $kx unless $args->{$kx};
    }

    return {
        valid   => 0,
        missing => \@missing,
        error   => sprintf('Required parameters missing: %s', join(', ', @missing)),
    };
}

sub _error_return {
    my $self  = shift;
    my $error = shift;

    $error = sprintf('%s. No API query was made.', $error);

    return {
        error   => 1,
        message => $error,
    };
}

sub _new_related_resource {
    my $self     = shift;
    my $base     = shift;
    my $resource = shift;

    return v4($resource)->new({
        auth_token => $self->auth_token,
        base_url   => $self->base_url,
        resource   => $base,
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource - base class for API resources.

=head1 DESCRIPTION

=head2 ATTRIBUTES

=over 4

=item C<auth_token>

An auth token to use in the headers for every API call. Authentication is
required to use the Mattermost API.

=item C<base_url>

The API's base URL.

=item C<resource>

The name of the API resource, for example C<WebService::Mattermost::V4::API::Brand>'s
resource is 'brand'.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

