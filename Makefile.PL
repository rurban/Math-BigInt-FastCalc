#!perl

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile
  (
   'NAME'               => 'Math::BigInt::FastCalc',
   'VERSION_FROM'       => 'lib/Math/BigInt/FastCalc.pm',
   'AUTHOR'             => 'Peter John Acklam <pjacklam@gmail.com>',
   'MIN_PERL_VERSION'   => 5.006001,
   'PREREQ_PM'          => {
                            #'ExtUtils::MakeMaker' => 6.58,
                            'XSLoader'            => 0,
                            'Test::More'          => 0.82,
                            'Math::BigInt'        => 1.999801,
                           },
   'INSTALLDIRS'        => 'perl',      # install over the core version
   'LICENSE'            => 'perl_5',
   'LIBS'               => [''],        # e.g., '-lm'
   'DEFINE'             => '',          # e.g., '-DHAVE_SOMETHING'
   'INC'                => '',          # e.g., '-I/usr/include/other'
   'SIGN'               => 1,
  );
