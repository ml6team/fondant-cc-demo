export METADATA='{"run_id":"test_niels", "base_path":"/Users/nielsrogge/Documents/fondant_artifacts_starcoder"}'

cd components/load_from_hub_stack/src
python main.py --metadata "$METADATA" --output_manifest_path /Users/nielsrogge/Documents/fondant_artifacts_starcoder/manifest/load_from_hub_stack/manifest.txt --dataset_name "ml6team/the-stack-smol-python"

cd ..
cd ..
cd pii_redaction/src
ls
python main.py --metadata "$METADATA" --input_manifest_path /Users/nielsrogge/Documents/fondant_artifacts_starcoder/manifest/load_from_hub_stack/manifest.txt --output_manifest_path /Users/nielsrogge/Documents/fondant_artifacts_starcoder/manifest/pii_redaction/manifest.txt 