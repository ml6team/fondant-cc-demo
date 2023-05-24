export BASE_PATH="/home/philippe/Scripts/fondant-cc-demo/local_artifacts"
export METADATA='{"run_id":"test-demo", "base_path":"/home/philippe/Scripts/fondant-cc-demo/local_artifacts"}'

echo $METADATA
cd components/load_from_hub_stack/src
python main.py \
 --metadata "$METADATA" \
 --output_manifest_path ${BASE_PATH}/load_from_hub_manifest.txt \
 --dataset_name "ml6team/the-stack-smol-python"
