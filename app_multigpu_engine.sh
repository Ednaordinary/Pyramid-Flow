#!/bin/bash

# Usage:
# ./app_multigpu_engine.sh GPUS VARIANT MODEL_PATH TASK TEMP GUIDANCE_SCALE VIDEO_GUIDANCE_SCALE RESOLUTION OUTPUT_PATH [IMAGE_PATH] PROMPT

GPUS=$1
VARIANT=$2
MODEL_PATH=$3
TASK=$4
TEMP=$5
GUIDANCE_SCALE=$6
VIDEO_GUIDANCE_SCALE=$7
RESOLUTION=$8
OUTPUT_PATH=$9
shift 9
# Now the remaining arguments are $@

if [ "$TASK" == "t2v" ]; then
    PROMPT="$1"
    IMAGE_ARG=""
elif [ "$TASK" == "i2v" ]; then
    IMAGE_PATH="$1"
    PROMPT="$2"
    IMAGE_ARG="--image_path $IMAGE_PATH"
else
    echo "Invalid task: $TASK"
    exit 1
fi

torchrun --nproc_per_node="$GPUS" \
    app_multigpu_engine.py \
    --model_path "$MODEL_PATH" \
    --variant "$VARIANT" \
    --task "$TASK" \
    --model_dtype bf16 \
    --temp "$TEMP" \
    --sp_group_size "$GPUS" \
    --guidance_scale "$GUIDANCE_SCALE" \
    --video_guidance_scale "$VIDEO_GUIDANCE_SCALE" \
    --resolution "$RESOLUTION" \
    --output_path "$OUTPUT_PATH" \
    --prompt "$PROMPT" \
    $IMAGE_ARG

