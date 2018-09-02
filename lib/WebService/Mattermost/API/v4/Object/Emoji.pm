package WebService::Mattermost::API::v4::Object::Emoji;

use Moo;
use Types::Standard qw(Str Int);

extends 'WebService::Mattermost::API::v4::Object';
with    qw(
    WebService::Mattermost::API::v4::Object::Role::Timestamps
    WebService::Mattermost::API::v4::Object::Role::BelongingToUser
    WebService::Mattermost::API::v4::Object::Role::ID
    WebService::Mattermost::API::v4::Object::Role::Name
);

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Object::Emoji

=head1 DESCRIPTION

Details a Mattermost Emoji object.

=head2 ATTRIBUTES

=over 4

=item C<id>

The Emoji's ID.

=item C<name>

The Emoji's name.

=item C<creator_id>

The ID of the user who created the Emoji.

=item C<create_at>

UNIX timestamp.

=item C<delete_at>

UNIX timestamp.

=item C<update_at>

UNIX timestamp.

=item C<created_at>

DateTime object.

=item C<deleted_at>

DateTime object.

=item C<updated_at>

DateTime object.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

