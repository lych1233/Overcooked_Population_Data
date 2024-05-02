#!/bin/bash
env="Overcooked"

# unident_s, random1, random3, distant_tomato, many_orders
layout=diverse_counter_circuit_6x5

num_agents=2
algo="mappo"
reward_command="(step, put_onion_on_X, player_1, accumulate, 5), (step, pickup_onion_from_X, player_1, accumulate, -5), (step, put_onion_on_X, player_0, accumulate, -5), (step, pickup_onion_from_X, player_0, accumulate, 5), (step, put_tomato_on_X, player_1, accumulate, 5), (step, pickup_tomato_from_X, player_1, accumulate, -5), (step, put_tomato_on_X, player_0, accumulate, -5), (step, pickup_tomato_from_X, player_0, accumulate, 5)"
exp="${0##*/}"
seed_max=4

echo "env is ${env}, layout is ${layout}, algo is ${algo}, exp is ${exp}, max seed is ${seed_max}"
for seed in `seq ${seed_max}`;
do
    echo "seed is ${seed}:"
    CUDA_VISIBLE_DEVICES=$1 python overcooked_population/self_play_reward_shaping.py --env_name ${env} --algorithm_name ${algo} --experiment_name ${exp} --layout_name ${layout} --num_agents ${num_agents} \
     --seed ${seed} --n_training_threads 1 --n_rollout_threads 100 --num_mini_batch 1 --episode_length 400 --num_env_steps 10000000 --reward_shaping_horizon 100000000 \
     --ppo_epoch 15 \
     --random_start_prob 0.0 \
     --cnn_layers_params "32,3,1,1 64,3,1,1 32,3,1,1" --save_interval 25 --log_inerval 10 --use_recurrent_policy \
     --trainer_reward_shaping_command "${reward_command}" \
     --wandb_name "WANDB_NAME" --user_name "USER_NAME" --use_wandb
done
