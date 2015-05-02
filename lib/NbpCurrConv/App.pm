package NbpCurrConv::App;

use strict;
use warnings;
use Getopt::Long;
use NbpCurrConv;
use Data::Dumper;
sub run{
  shift;
  my ($from, $to, $amount) = @_;
  
  my $ncc = NbpCurrConv->new();
  return $ncc->convert($from, $to, $amount);
}
1;
