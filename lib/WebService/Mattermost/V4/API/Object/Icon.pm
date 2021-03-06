package WebService::Mattermost::V4::API::Object::Icon;

# ABSTRACT: An icon item.

use Moo;

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::ID
    WebService::Mattermost::V4::API::Object::Role::Message
    WebService::Mattermost::V4::API::Object::Role::RequestID
    WebService::Mattermost::V4::API::Object::Role::StatusCode
);

################################################################################

1;
__END__

=head1 DESCRIPTION

Details a Mattermost Icon object.

=head2 ATTRIBUTES

=over 4

=item C<status_code>

=item C<request_id>

=back

=head1 SEE ALSO

=over 4

=item L<WebService::Mattermost::V4::API::Object::Role::ID>

=item L<WebService::Mattermost::V4::API::Object::Role::Message>

=item L<WebService::Mattermost::V4::API::Object::Role::RequestID>

=item L<WebService::Mattermost::V4::API::Object::Role::StatusCode>

=back
