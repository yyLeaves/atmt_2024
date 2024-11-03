#!/bin/bash

# Directory containing the checkpoints
CHECKPOINT_DIR="assignments/03/output"


# Loop through all checkpoint files
for checkpoint in "$CHECKPOINT_DIR"/en-fr_bs*; do
    echo "Processing checkpoint $checkpoint"
    experiment_name=$(echo "$checkpoint" | grep -o 'en-fr[^/]*')
    echo "Experiment name: $experiment_name"

    if [ -z "$experiment_name" ]; then
        echo "Could not extract experiment name from $checkpoint, skipping..."
        continue
    fi

    echo "Translating with checkpoint $checkpoint"
    python translate.py \
        --data data/en-fr/prepared/ \
        --dicts data/en-fr/prepared/ \
        --checkpoint-path "$checkpoint/checkpoints/checkpoint_best.pt" \
        --output "assignments/03/output/${experiment_name}/translations.txt" \
        --log-file "logs/${experiment_name}_inference.log" \
        --batch-size 1
    echo "Done translating with checkpoint $checkpoint"

    echo "Postprocessing translations"
    bash scripts/postprocess.sh \
        "assignments/03/output/${experiment_name}/translations.txt" \
        "assignments/03/output/${experiment_name}/translations.p.txt" \
        en
    echo "Done postprocessing translations"

    echo "Calculating BLEU score for $experiment_name:"
    cat "assignments/03/output/${experiment_name}/translations.p.txt" | sacrebleu data/en-fr/raw/test.en > "assignments/03/output/${experiment_name}/bleu.txt"
    
    echo "Completed processing, postprocessing, and evaluation for $checkpoint"
    echo "--------------------------------"


git add .
git commit -m "Translations completed for $experiment_name"
git push

done