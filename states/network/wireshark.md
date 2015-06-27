
### wireshark

Installs wireshark's `tshark` command-line tool.

#### Example Wireshark commands

- Show version: `tshark -v`
- Show captureable interfaces and exit: `tshark -D`
- Capture a specific protocol and interface: `tshark -f "tcp port 22" -i enp0s20f1`
- Filter: `tshark -R "ip.addr == 192.168.0.1"`
- Filter NFS traffic: `tshark -R nfs`
- Capture packet data to a file: `tshark -w /tmp/capture.pcap`
- Auto-save Captures to multiple files: `tshark -b filesize:10 -a files:5 -w /tmp/temp.pcap`
  * -b is the ring buffer option
  * -a is the capture autostop condition
- Read packet data from a file: `tshark -r /tmp/capture.pcap`

- Set capture buffer size to 2MB: `tshark -B 2`

#### References
- [tshark man page](https://www.wireshark.org/docs/man-pages/tshark.html)
- [How to Use Wireshark Tshark to Specify File, Time, Buffer Capture Limits](http://www.thegeekstuff.com/2014/05/wireshark-file-buffer-size/)
- [Tshark examples: howto capture and dissect network traffic](http://www.codealias.info/technotes/the_tshark_capture_and_filter_example_page)
