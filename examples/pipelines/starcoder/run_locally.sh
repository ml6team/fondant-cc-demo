export BASE_PATH="/home/philippe/Scripts/fondant-cc-demo/local_artifacts"
export METADATA='{"run_id":"test-demo", "base_path":"/home/philippe/Scripts/fondant-cc-demo/local_artifacts"}'

cd components/load_from_hub_stack/src
python main.py \
 --metadata "$METADATA" \
 --output_manifest_path ${BASE_PATH}/manifest/load_from_hub_stack/manifest.txt \
 --dataset_name "ml6team/the-stack-smol-python"

cd ../..
cd filter_metadata/src
python main.py \
 --metadata "$METADATA" \
 --input_manifest_path ${BASE_PATH}/manifest/load_from_hub_stack/manifest.txt \
 --output_manifest_path ${BASE_PATH}/manifest/filter_metadata/manifest.txt \
 --avg_line_length_threshold 10 \
 --max_line_length_threshold 100 \
 --alphanum_fraction_threshold 0.25

cd ../..
cd comments_filtering/src
python main.py \
 --metadata "$METADATA" \
 --input_manifest_path ${BASE_PATH}/manifest/filter_metadata/manifest.txt \
 --output_manifest_path ${BASE_PATH}/manifest/comments_filtering/manifest.txt \
 --min_comments_ratio 0.1 \
 --max_comments_ratio 0.9


cd ../..
cd pii_redaction/src
python main.py \
 --metadata "$METADATA" \
 --input_manifest_path  ${BASE_PATH}/manifest/comments_filtering/manifest.txt \
 --output_manifest_path ${BASE_PATH}/manifest/pii_redaction/manifest.txt