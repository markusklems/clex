#!/bin/bash

CBONIP=107.21.83.110
OSP=6379
LSP=5114
MSP=27017

nc -z $CBONIP $OSP; echo $?
nc -z $CBONIP $LSP; echo $?
nc -z $CBONIP $MSP; echo $?