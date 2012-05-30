#!/usr/bin/env qore

%requires tibae
%require-our
%enable-all-warnings

%requires qore >= 0.8.4

#const Subject = "Qore.Test.QORETest";
const Subject = "test";

our int $iters = int(shift $ARGV);
if (!$iters)
    $iters = 100;

our int $threads = int(shift $ARGV);
if (!$threads)
    $threads = 1;

printf("%d iteration(s) %d thread(s)\n", $iters, $threads);

const test_class = "/tibco/public/class/ae/Test";

TibcoAdapter sub testInit() {
    # Application properties for adapter
    my hash $props = (
	"AppVersion": Qore::VersionString,
	"AppInfo": "test",
	"AppName": "testAdapter",
	"RepoURL": get_script_dir() + "/new.dat",
	"ConfigURL": "/tibco/private/adapter/testAdapter",
	);
    my hash $classes.Test = test_class;

    print("initializing TIBCO session: \n");
    my TibcoAdapter $adapter("rvSession", $props, $classes);#, "8504", "172.23.3.137", "172.23.5.143:7500");
    print("done\n");
    return $adapter;
}

const MsgIn = (
    "STRING"   : "hello there",
    "INTEGER"  : 2501234,
    "DATE"     : 2005-03-10,
    "DATETIME" : 2007-06-05T15:48:37.145,
    "BOOLEAN"  : True,
    "FLOAT"    : 123.23443,
    "I1"       : 110,
    "I2"       : 21312,
    "I4"       : 24983942,
    "I8"       : 349389023848234,
    "U1"       : -76,
    "U2"       : -20534,
    "U4"       : 34904932,
    "U8"       : 491934783039821,
    "R4"       : 154.0,
    "R8"       : 239349871094.2334,
    "BINARY"   : <beadface>,
    "TIME"     : 12:35:01.145,
    "INTERVAL" : 439395s,
    );

const MsgOut = (
    "STRING"   : MsgIn.STRING,
    "INTEGER"  : MsgIn.INTEGER,
    "DATE"     : MsgIn.DATE,
    "DATETIME" : MsgIn.DATETIME,
    "BOOLEAN"  : MsgIn.BOOLEAN,
    "FLOAT"    : MsgIn.FLOAT,
    "BINARY"   : MsgIn.BINARY,
    "I1"       : tibae_type(TIBAE_I1, MsgIn.I1),
    "I2"       : tibae_type(TIBAE_I2, MsgIn.I2),
    "I4"       : tibae_type(TIBAE_I4, MsgIn.I4),
    "I8"       : tibae_type(TIBAE_I8, MsgIn.I8),
    "U1"       : tibae_type(TIBAE_U1, MsgIn.U1),
    "U2"       : tibae_type(TIBAE_U2, MsgIn.U2),
    "U4"       : tibae_type(TIBAE_U4, MsgIn.U4),
    "U8"       : tibae_type(TIBAE_U8, MsgIn.U8),
    "R4"       : tibae_type(TIBAE_R4, MsgIn.R4),
    "R8"       : tibae_type(TIBAE_R8, MsgIn.R8),
    "TIME"     : tibae_type(TIBAE_TIME, MsgIn.TIME),
    "INTERVAL" : tibae_type(TIBAE_INTERVAL, 5D + 2h + 3m + 15s + 251ms ),
    );

sub sendTest(TibcoAdapter $adapter, string $subject) {
    # use the class repository path directly
    $adapter.sendSubject($subject, test_class, MsgOut);
}

sub sendExitMsg(TibcoAdapter $adapter, string $subject) {
    my hash $msg = ("STRING": "exit");
    # look up the class path using the class hash passed to the TibcoAdapter constructor
    $adapter.sendSubject($subject, "Test", $msg);
}

sub send(TibcoAdapter $adapter, string $subject, Counter $done) {
    # signal parent thread that we're done on exit
    on_exit $done.dec();

    $subject += ".1";
    printf("sending %s\n", $subject);
    my $cnt = 0;
    $go.waitForZero();
    printf("running sender %s\n", $subject);
    for (my int $i = 0; $i < $iters; $i++) {
	sendTest($adapter, $subject);
	if (!(++$cnt % 10))
	    print("S");
    }
    sendExitMsg($adapter, $subject);
    printf("%d messages sent\n", $iters + 1);
}

sub receive(TibcoAdapter $adapter, string $subject, Counter $done) {
    # signal parent thread that we're done on exit
    on_exit $done.dec();
    my int $cnt = 0;

    $subject += ".>";
    printf("listening on %s\n", $subject);
    # set up the listener
    $adapter.receive($subject, 1);
    $go.waitForZero();
    printf("running listener %s\n", $subject);
    while (True) {
	my $msg = $adapter.receive($subject, 5000);
	usleep(5000);
	if (!exists $msg)
	    break;
	if (!(++$cnt % 10))
	    print("R");
	if ($msg.msg.STRING == "exit")
	    break;

	foreach my string $k in (keys MsgIn) {
	    if ($msg.msg.$k != MsgIn.$k) {
		printf("error in field %n: recvd=%N, expected=%N\n", $k, $msg.msg.$k, MsgIn.$k);
		return;
	    }
	}
    }
    printf("\n%d messages received\n", $cnt);
}

our Counter $go();

sub doTest() {
    my list $a = ();
    for (my int $i = 0; $i < $threads; $i++)
	$a += testInit();

    my Counter $done();
    $go.inc();
    for (my int $i = 0; $i < $threads; $i++) {
	my string $subject = sprintf("%s.%d.1", Subject, $i);

	$done.inc();
	background receive($a[$i], $subject, $done);
	$done.inc();
	background send($a[$i], $subject, $done);
    }

    $go.dec();
    $done.waitForZero();
}

doTest();
