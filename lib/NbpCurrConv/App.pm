package NbpCurrConv::App;

use strict;
use warnings;
use Getopt::Long;
use NbpCurrConv;
sub run{
  my $from; 
  my $to;
  my $amount;
  
  my $ncc = NbpCurrConv->new();
  return $ncc->convert($from, $to, $amount);
}
1;
