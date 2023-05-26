"""Dataset creation pipeline config"""
from dataclasses import dataclass


@dataclass
class PipelineConfig:
    """
    General Pipeline Configs
    Params:
        BASE_PATH (str): the base path used to store the artifacts
        HOST (str): the kfp host url
    """

    BASE_PATH = "gs://boreal-array-387713_kfp-artifacts/custom_artifact"
    HOST = "https://72685a629ca861a3-dot-europe-west1.pipelines.googleusercontent.com"