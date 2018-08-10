package Net::Mattermost::API::v4::Resource;

use DDP;
use List::MoreUtils 'all';
use Moo;
use Types::Standard qw(HashRef Str);
use Switch::Plain;

use Net::Mattermost::API::Request;

with 'Net::Mattermost::Role::UserAgent';

################################################################################

has base_url   => (is => 'ro', isa => Str, required => 1);
has resource   => (is => 'ro', isa => Str, required => 1);
has auth_token => (is => 'rw', isa => Str, required => 0);

has delete  => (is => 'ro', isa => Str,     default => 'DELETE');
has get     => (is => 'ro', isa => Str,     default => 'GET');
has headers => (is => 'ro', isa => HashRef, default => sub { {} });
has post    => (is => 'ro', isa => Str,     default => 'POST');
has put     => (is => 'ro', isa => Str,     default => 'PUT');
has rules   => (is => 'rw', isa => HashRef, default => sub { {} });

################################################################################

sub _call {
    my $self = shift;
    my $args = shift;

    if ($args->{required}) {
        my $validation = $self->_validate($args->{parameters}, $args->{required});

        return $validation unless $validation->{valid};
    }

    my %headers = ('Keep-Alive' => 1);

    if ($self->auth_token) {
        $headers{Cookie}        = sprintf('MMAUTHTOKEN=%s', $self->auth_token);
        $headers{Authorization} = sprintf('Bearer %s', $self->auth_token);
    }

    my $request = $self->_as_request($args);
    my $tx;

    sswitch ($request->method) {
        case $self->post: {
            $tx = $self->ua->post(
                $request->url => \%headers,
                json          => $request->parameters,
            );
        }
        case $self->get: {
            $tx = $self->ua->get(
                $request->url => \%headers,
                form          => $request->parameters,
            );
        }
        case $self->put: {

        }
        case $self->delete: {

        }
    }

    return $tx->res;
}

sub _as_request {
    my $self = shift;
    my $args = shift;

    $args->{base_url} = $self->base_url;
    $args->{resource} = $self->resource;

    $args->{endpoint} ||= '';

    return Net::Mattermost::API::Request->new($args);
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

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::API::v4::Resource - base class for API resources.

=head1 DESCRIPTION

=head2 ATTRIBUTES

=over 4

=item C<resource>

The name of the API resource, for example C<Net::Mattermost::API::v4::Brand>'s
resource is 'brand'.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

