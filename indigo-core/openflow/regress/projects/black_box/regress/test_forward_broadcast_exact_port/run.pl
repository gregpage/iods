#!/usr/bin/perl -w
# test_forward_exact_port

use strict;
use OF::Includes;

sub forward_broadcast {
    my ($sock, $options_ref) = @_;

    my $in_port = $$options_ref{'port_base'};
    my $out_port = $in_port + 1;

    my $len = $$options_ref{'pkt_len'};
    my $pkt_args = {
	DA => "FF:FF:FF:FF:FF:FF",
	SA => "00:00:00:00:00:0" . ($in_port),
	src_ip => "192.168." . ($in_port) . "." . ($out_port),
	dst_ip => "255.255.255.255",
	ttl => 64,
	len => $len,
	src_port => 1,
	dst_port => 0
    };
    my $test_pkt = new NF2::UDP_pkt(%$pkt_args);

    my $wildcards = 0x0000;
    my $flags = $enums{'OFPFF_SEND_FLOW_REM'};
    my $flow_mod_pkt;
    $flow_mod_pkt = create_flow_mod_from_udp($ofp, $test_pkt, $in_port, $out_port, $$options_ref{'max_idle'}, $flags, $wildcards);

    # Send 'flow_mod' message
    syswrite($sock, $flow_mod_pkt);
    print "sent flow_mod message\n";

    # Give OF switch time to process the flow mod
    usleep($$options_ref{'send_delay'});

    nftest_send("eth" . ($in_port), $test_pkt->packed);

    # expect single packet
    print "expect single packet\n";
    nftest_expect("eth" . ($out_port), $test_pkt->packed);

    print "wait \n";
    wait_for_flow_expired_all($ofp, $sock, $options_ref);
}

run_black_box_test(\&forward_broadcast, \@ARGV);
