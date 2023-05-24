"""A component that detects Personal Identifiable Information (PII) in code."""

import logging
import json

from utils.emails_ip_addresses_detection import detect_email_addresses
from utils.keys_detection import detect_keys

import dask.dataframe as dd
from dask.dataframe import from_pandas
import pandas as pd

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


def scan_pii(text, key_detector="other"):
    """Scan a piece of code to detect PII
    This add 3 columns to the dataset:
    - secrets: (list) of secrets/PII found
    - has_secrets: (bool) whether the example contains secrets/PII
    - num_secrests (int) number of secrets
    """
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
    
    return matches, has_secrets, len(secrets)


class DetectPIIComponent(TransformComponent):
    """
    Component that detects PII in code.
    """

    def transform(
        self,
        *,
        dataframe: dd.DataFrame,
    ) -> dd.DataFrame:
        """
        Args:
            dataframe: Dask dataframe

        Returns:
            Dask dataframe
        """
        result = dataframe.apply(lambda example: scan_pii(text=example.code_content), axis=1, result_type="expand", meta={0: object, 1: bool, 2: int},)
        result.columns = ["code_secrets", "code_has_secrets", "code_number_secrets"]
        
        dataframe = dataframe.merge(
            result, left_index=True, right_index=True
        )

        return dataframe
    

if __name__ == "__main__":
    component = DetectPIIComponent.from_file()
    component.run()