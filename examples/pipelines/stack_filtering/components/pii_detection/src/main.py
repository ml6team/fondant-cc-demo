"""A component that detects Personal Identifiable Information (PII) in code."""

import logging
import json

from utils.emails_ip_addresses_detection import detect_email_addresses
from utils.keys_detection import detect_keys

import dask.dataframe as dd
from datasets import load_dataset

from fondant.component import TransformComponent
from fondant.logger import configure_logging

configure_logging()
logger = logging.getLogger(__name__)


def postprocess_secrets(secrets):
    """Postprocess the secrets found by the scan_secrets function"""
    if secrets:
        matches = json.dumps(secrets)
        has_secrets = True
    else:
        matches = json.dumps([])
        has_secrets = False
    return matches, has_secrets


class DetectPIIComponent(TransformComponent):
    """
    Component that detects PII in code.
    """

    def transform(
        self,
        *,
        dataframe: dd.DataFrame,
        batch_size: int,
    ) -> dd.DataFrame:
        """
        Args:
            dataframe: Dask dataframe
            batch_size: batch size to use when processing

        Returns:
            Dask dataframe
        """
        return -1


def scan_pii_batch(examples, key_detector="other"):
    """Scan a batch of examples from a dataset to detect PII
    This add two columns to the dataset:
    - secrets: (list) of secrets/PII found
    - has_secrets: (bool) whether the example contains secrets/PII
    """
    list_secrets = []
    list_has_secrets = []
    number_secrets = []
    for text in examples["content"]:
        secrets = []
        if key_detector == "regex":
            # use a regex to detect keys + emails + ips
            secrets = secrets + detect_email_addresses(
                text, tag_types={"KEY", "EMAIL", "IP_ADDRESS"}
            )
        else:
            # detect emails and ip addresses with regexes
            secrets = secrets + detect_email_addresses(
                text, tag_types={"EMAIL", "IP_ADDRESS"}
            )
            # for keys use detect-secrets tool
            secrets = secrets + detect_keys(text)
        # to add this as new columns to datasets we need the same number of samples in each row
        # we save secrets as json strings instead of lists
        matches, has_secrets = postprocess_secrets(secrets)
        list_secrets.append(matches)
        list_has_secrets.append(has_secrets)
        number_secrets.append(len(secrets))
    return {
        "secrets": list_secrets,
        "has_secrets": list_has_secrets,
        "number_secrets": number_secrets,
    }

dataset = load_dataset("bigcode/the-stack-smol", data_dir="data/python")

print("Original columns:", dataset["train"].features)

updated_dataset = dataset.map(scan_pii_batch, batched=True, batch_size=100, num_proc=8, load_from_cache_file=False)

print("New columns:", updated_dataset["train"].features)