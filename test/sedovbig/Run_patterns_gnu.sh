#!/bin/bash -l

cd /usr/projects/hpctools/hpp/PENNANT/test/sedovbig

export PATH=/usr/projects/artab/protected/armie/armie/build/bin64:$PATH
module swap PrgEnv-cray PrgEnv-gnu

export CRAY_CPU_TARGET=arm-sve

# Run with ArmIE
echo "Memory pattern study for different SVE vector lengths"

#for i in 256 512 1024 2048
for i in 256 512 1024 2048
do
  echo "MEMPATTERNS emulated SVE vector length of "$i" bitst"
  armie -ilibmempatterns_emulated.so -elibmempatterns_sve_$i.so -- ./pennant.gnu83cp.sve sedovbig.pnt
  echo ""
done

