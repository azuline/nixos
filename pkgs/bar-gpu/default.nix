{ writeShellScriptBin, gawk }:

# Currently hardcodes the ID of the GPU bus (A) we use on splendor.
writeShellScriptBin "bar-gpu" ''
  NVIDIA_SMI="/run/current-system/sw/bin/nvidia-smi"
  INTEL_GPU_TOP="/run/current-system/sw/bin/intel_gpu_top"

  if [ -x "$NVIDIA_SMI" ]; then
    "$NVIDIA_SMI" --id=00000000:0A:00.0 --query-gpu=utilization.gpu --format=csv,noheader,nounits | ${gawk}/bin/awk '{ printf "0.%02i", $1}'
  elif [ -x "$INTEL_GPU_TOP" ]; then
    "$INTEL_GPU_TOP" -s 500 -l 2>/dev/null | ${gawk}/bin/awk 'NR==3 {print int($7)"%"; exit}'
  else
    exit 1
  fi
''
