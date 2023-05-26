export BASE_PATH="$PWD/fondant_artifacts_starcoder"
export METADATA="{'run_id':'test-demo', 'base_path':'${BASE_PATH}'}"

# Using sed to replace single quotes with double quotes
METADATA=$(echo "$METADATA" | sed "s/'/\"/g")

mkdir ${BASE_PATH}

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