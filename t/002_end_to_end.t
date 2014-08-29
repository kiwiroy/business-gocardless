#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep;
use Test::Exception;
use LWP::Simple;
use Business::GoCardless;

use FindBin qw/ $Bin /;

my ( $token,$url,$app_id,$app_secret,$mid ) = @ENV{qw/
    GOCARDLESS_TOKEN
    GOCARDLESS_TEST_URL
    GOCARDLESS_APP_ID
    GOCARDLESS_APP_SECRET
    GOCARDLESS_MERCHANT_ID
/};

my $GoCardless = Business::GoCardless->new(
    token           => $token // 'DHDEF68S410DTCGNGDNA3DYDD5R',
    client_details  => {
        base_url    => $url        // 'http://localhost:3000',
        app_id      => $app_id     // '6S1YGHNAJRWZ5A9ZXT6XG630FZSJ1YF8PFTNF99',
        app_secret  => $app_secret // '0PSE62M1Z4VDMRB101ZF8BVGCBS3WWY2K5FYJPC',
        merchant_id => $mid        // '1DJUN3H1I2',
    },
);

isa_ok( $GoCardless,'Business::GoCardless' );

my $new_url = $GoCardless->client->new_bill_url({
    amount       => 100,
    name         => 'Example payment',
    redirect_uri => "http://localhost:3000/merchants/$mid/confirm_resource",
});

note $new_url;

note $GoCardless->client->confirm_resource({
    resource_uri  => 'https://sandbox.gocardless.com/api/v1/bills/0PRKT94DND',
    resource_id   => '0PRKT94DND',
    resource_type => 'bill',
    signature     => 'f2a3600a7720d3a549a2eef859e1cba070b4f3531f8e45f40adc0786b84b3c73',
    #state =>
});

done_testing();