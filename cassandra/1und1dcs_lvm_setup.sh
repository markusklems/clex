#!/bin/bash
lvextend -L +700G /dev/vg00/var
lvextend -L +10G /dev/vg00/home
sleep 10
resize2fs /dev/vg00/var
sleep 10
resize2fs /dev/vg00/home