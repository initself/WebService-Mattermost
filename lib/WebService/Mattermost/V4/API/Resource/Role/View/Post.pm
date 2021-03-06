package WebService::Mattermost::V4::API::Resource::Role::View::Post;

# ABSTRACT: Links a resource to the post view.

use Moo::Role;
use Types::Standard 'Str';

################################################################################

has view_name => (is => 'ro', isa => Str, default => 'Post');

################################################################################

1;
__END__

=head1 DESCRIPTION

Set a resource as using the L<WebService::Mattermost::V4::API::Object::Post>
view.

=head1 ATTRIBUTES

=over 4

=item C<view_name>

=back
