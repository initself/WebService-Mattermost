package WebService::Mattermost::V4::API::Resource::Teams;

use Moo;
use Types::Standard 'InstanceOf';

use WebService::Mattermost::V4::API::Resource::Teams::Channels;
use WebService::Mattermost::Helper::Alias 'v4';

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

has channels => (is => 'ro', isa => InstanceOf[v4 'Teams::Channels'], lazy => 1, builder => 1);

################################################################################

around [ qw(get_by_id) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        endpoint => '%s',
        ids      => [ $id ],
        view     => 'Team',
    });
}

sub channel_by_name_and_team_name {
    # GET /name/{name}/channels/name/{channel_name}
}

################################################################################

sub _build_channels {
    my $self = shift;

    return $self->_new_related_resource('teams', 'Teams::Channels');
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::Teams

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->teams;

=head2 METHODS

=over 4

=back

