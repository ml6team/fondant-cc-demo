export BASE_PATH="/Users/nielsrogge/Documents/fondant_artifacts_starcoder"
export METADATA='{"run_id":"test-demo", "base_path":"/Users/nielsrogge/Documents/fondant_artifacts_starcoder"}'

cd components/load_from_hub_stack/src
python main.py \
 --metadata "$METADATA" \
 --output_manifest_path ${BASE_PATH}/manifest/load_from_hub_stack/manifest.txt \
 --dataset_name "ml6team/the-stack-smol-python"

cd ../..
cd pii_redaction/src
python main.py \
 --metadata "$METADATA" \
 --input_manifest_path  ${BASE_PATH}/manifest/load_from_hub_stack/manifest.txt \
 --output_manifest_path ${BASE_PATH}/manifest/pii_redaction/manifest.txt