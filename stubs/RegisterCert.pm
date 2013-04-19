#!/usr/bin/perl -w

# Stubbed because the original module depends on Perl modules from the
# limal-ca-mgm-perl package, which is not present in openSUSE 12.3.

package RegisterCert;

use strict;

our %TYPEINFO;

BEGIN { $TYPEINFO{parseCertificate} = ["function", ["map", "string", "any"], "string"]; }
sub parseCertificate { }
