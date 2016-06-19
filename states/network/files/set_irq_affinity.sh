#! /bin/bash
if [ -z $1 ]; then
    echo "usage: $0 <interface> [2nd interface]"
    exit 1
fi
CORES=$((`cat /proc/cpuinfo | grep processor | tail -1 | awk '{print $3}'`+1))
hop=2

if [ -z $2 ]; then
    limit_1=$((2**CORES))
    echo "---------------------------------------"
    echo "Optimizing IRQs for Single port traffic"
    echo "---------------------------------------"
else
    echo "-------------------------------------"
    echo "Optimizing IRQs for Dual port traffic"
    echo "-------------------------------------"
    limit_1=$(( 2**$((CORES/2)) ))
    limit_2=$((2**CORES))
    IRQS_2=$(cat /proc/interrupts | grep $2 | awk '{print $1}' | sed 's/://')
fi

IRQS_1=$(cat /proc/interrupts | grep $1 | awk '{print $1}' | sed 's/://')

if [ -z "$IRQS_1" ] ; then
    echo No IRQs found for $1.
else
    echo Discovered irqs for $1: $IRQS_1
    mask=1 ; for IRQ in $IRQS_1 ; do echo Assign irq $IRQ mask 0x$(printf "%x" $mask) ; echo $(printf "%x" $mask) > /proc/irq/$IRQ/smp_affinity ; mask=$(( mask * $hop)) ; if [ $mask -ge $limit_1 ] ; then mask=1; fi ;done
fi

echo 

if [ "$2" != "" ]; then
    if [ -z "$IRQS_2" ]; then
        echo No IRQs found for $1.
    else
        echo Discovered irqs for $2: $IRQS_2
        mask=$limit_1 ; for IRQ in $IRQS_2 ; do echo Assign irq $IRQ mask 0x$(printf "%x" $mask) ; echo $(printf "%x" $mask) > /proc/irq/$IRQ/smp_affinity ; mask=$(( mask * $hop)) ; if [ $mask -ge $limit_2 ] ; then mask=$limit_1 ; fi ;done
    fi
fi
echo 
echo done. 

