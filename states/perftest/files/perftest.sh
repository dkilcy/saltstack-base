HOST=ring-a2

for p in 1 2 4 8; do 
   for w in 512K 1M 2M 4M; do 
       for l in 64K 128K 256K 512K 1M 2M 4M; do 
           iperf3 -t 5 -c $HOST -P $p -M 9000 -w $w -l $l 2>&1; 
           echo "Tested p:$p, w:$w, l:$l"; 
           echo "-----"; sleep 1; 
       done; 
       sleep 1; 
   done; 
   sleep 1; 
done
