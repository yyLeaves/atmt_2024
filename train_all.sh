#!/bin/bash
batch_sizes=(1 4)
learning_rates=(0.0003 0.0006 0.0012 0.0024 0.0048 0.0096)

for bs in "${batch_sizes[@]}"; do
    for lr in "${learning_rates[@]}"; do
        # Modified to ensure 4 digits after removing decimal point
        lr_str=$(printf "%.4f" $lr | sed 's/\.//g')
        lr_str=${lr_str#"0"}
        
        output_dir="assignments/03/output/en-fr_bs${bs}_lr${lr_str}/checkpoints/"
        mkdir -p "$output_dir"
        
        # Log file path
        log_file="logs/en-fr_bs${bs}_lr${lr_str}.log"
        
        echo "Running training with batch size $bs and learning rate $lr to $output_dir"
        
        python train.py \
            --data data/en-fr/prepared \
            --source-lang fr \
            --target-lang en \
            --save-dir "$output_dir" \
            --log-file "$log_file" \
            --batch-size "$bs" \
            --lr "$lr"

        git add .
        git commit -m "Training results: BS=$bs, LR=$lr"
        git push
        
        sleep 1
    done
done

# echo -e "\nTraining completed. Starting Git operations..."
# git add .
# datetime=$(date '+%Y-%m-%d %H:%M:%S')
# commit_msg="Training results: BS=[1,4,16], LR=[0.0003-0.0096] - Run at $datetime"
# git commit -m "$commit_msg"
# git push
# echo "Committed and pushed with message: $commit_msg"
