#Implement 3 nodes point to point network with duplex links between them. Set the queue size, vary the bandwidth and find the number of packets dropped.
set ns [new Simulator]

set tracefile [open out.tr w]
$ns $trace-all $tracefile
set namfile [open out.nam w]
$ns $namtrace-all $namfile

set n0[$ns node]
set n1[$ns node]
set n2[$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail

$ns queue-limit $n0 $n1 5
$ns queue-limit $n1 $n2 5

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink[new Agent/TCPSink]
$ns attach-agent $n5 $sink

$ns connect $tcp $sink

set cbr [new Applicaation/Traffic/CBR]
$ns attach-agent $cbr

proc finish{} {
  global ns tracefile namfile
  $ns flush-trace
  close $tracefile
  close $namfile
  exec nam out.nam &
  exec echo "no of packets dropped" &
  exec trace out.tr &
  exit 0
}
$ns at 0.1 "$cbr start"
$ns at 5.0 "$cbr stop"
$ns at 5.5 "finish"
$ns run
