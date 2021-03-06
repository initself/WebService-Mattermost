package WebService::Mattermost::V4::API::Resource::System;

# ABSTRACT: Wrapped API methods for the system API endpoints.

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

sub ping {
    my $self = shift;

    return $self->_single_view_get({
        endpoint => 'ping',
        view     => 'Status',
    });
}

################################################################################

1;
__END__

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->system;

=head2 METHODS

=over 4

=item C<ping()>

L<Check system health|https://api.mattermost.com/#tag/system%2Fpaths%2F~1system~1ping%2Fget>

    my $response = $resource->ping();

=back
