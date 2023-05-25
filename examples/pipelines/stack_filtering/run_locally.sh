export BASE_PATH="/home/philippe/Scripts/fondant-cc-demo/local_artifacts"
export METADATA='{"run_id":"test-demo", "base_path":"/home/philippe/Scripts/fondant-cc-demo/local_artifacts"}'


cd components/load_from_hub_stack/src
python main.py \
 --metadata "$METADATA" \
 --output_manifest_path ${BASE_PATH}/load_from_hub_manifest.txt \
 --dataset_name "ml6team/the-stack-smol-python"

cd ../..
cd filter_metadata/src
python main.py \
 --metadata "$METADATA" \
 --input_manifest_path ${BASE_PATH}/load_from_hub_manifest.txt \
 --output_manifest_path ${BASE_PATH}/filter_metadata_manifest.txt \
 --avg_line_length_threshold 10 \
 --max_line_length_threshold 100 \
 --alphanum_fraction_threshold 0.25

cd ../..
cd comments_filtering/src
python main.py \
 --metadata "$METADATA" \
 --input_manifest_path ${BASE_PATH}/load_from_hub_manifest.txt \
 --output_manifest_path ${BASE_PATH}/comments_filtering_manifest.txt \
 --min_comments_ratio 0.1 \
 --max_comments_ratio 0.9

