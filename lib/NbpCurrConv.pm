package NbpCurrConv;

use 5.006;
use strict;
use warnings FATAL => 'all';
use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use Carp;
binmode STDOUT, ":utf8";

=head1 NAME

NbpCurrConv

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use CurrConv;

    my $foo = CurrConv->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut


sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  $self->_init();
  return $self;
}

sub convert {
  my $self = shift;
  my ($from, $to, $amount) = @_;

  die 'No PLN passed as from or to' unless ($from eq 'PLN' || $to eq 'PLN');
  die 'The amount has a strange value' unless $amount =~ /^\d+(?:\.\d+)?$/;
  return $amount if ($from eq $to);

  my $curr_to_find = $from eq 'PLN' ? $to : $from;
  my $curr_data = $self->{data}->{currencies}->{$curr_to_find};
  die "Couldn't find $curr_to_find currency!" if !defined($curr_data);
  if ($from eq $curr_to_find){
    $amount *= $curr_data->{exchange_rate};
  }else{
    $amount /= $curr_data->{exchange_rate};
  }

  return $amount;
}

sub _init {
  my $self = shift;
  my $xml_file = $self->_get_file('http://nbp.pl/kursy/xml/LastA.xml');
  $self->{data} = $self->_parse_xml($xml_file);
}

sub _parse_xml {
  my $self = shift;
  my $body = shift;
  my $xml = XMLin($body);
  my $data = {};
  $data->{date} = $xml->{data_publikacji};
  foreach my $elem (@{$xml->{pozycja}}){
    $elem->{kurs_sredni} =~ s/\,/\./;
    $data->{currencies}->{$elem->{kod_waluty}} = { multipler => $elem->{przelicznik}, exchange_rate => $elem->{kurs_sredni},
                                                   name => $elem->{nazwa_waluty} };
  }
  return $data;
}

sub _get_file {
  my $self = shift;
  my $url = shift;
  my $content = get($url);
  die "Couldn't get: $url" unless defined $content;
  return $content;
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Dariusz Piwowarski, C<< <piwowarskidariusz at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-currconv at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CurrConv>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CurrConv


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CurrConv>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CurrConv>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CurrConv>

=item * Search CPAN

L<http://search.cpan.org/dist/CurrConv/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Dariusz Piwowarski.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of CurrConv
