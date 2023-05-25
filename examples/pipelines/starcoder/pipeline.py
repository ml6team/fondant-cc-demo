"""Pipeline used to create the dataset to train the StarCoder model."""

import logging
import sys

sys.path.append("../")

from pipeline_configs import PipelineConfigs

from fondant.pipeline import ComponentOp, Pipeline, Client
from fondant.logger import configure_logging

configure_logging()
logger = logging.getLogger(__name__)

# Pipeline description
team_name = "cheesecake"  # TODO: insert your team name
hf_token = ""  # TODO: insert your HF token
pipeline_name = f"Stack filtering pipeline {team_name}"
pipeline_description = "A pipeline for filtering the stack dataset"

# Initialize pipeline and client
pipeline = Pipeline(pipeline_name=pipeline_name,
                    pipeline_description=pipeline_description,
                    base_path=PipelineConfigs.BASE_PATH)
client = Client(host=PipelineConfigs.HOST)

load_from_hub_op = ComponentOp(
    name="load_from_hub_stack",
    arguments={"dataset_name": "ml6team/the-stack-smol-python"},
)
pii_redaction_op = ComponentOp(
    name="pii_redaction",
)

# TODO: add more components
# your_custom_component_op = ComponentOp(
#     name="your_custom_component",  # TODO: rename to the same name of your component
#     arguments={},  # TODO: insert your component's arguments here
# )

pipeline.add_op(load_from_hub_op)
pipeline.add_op(pii_redaction_op, dependencies=load_from_hub_op)
# TODO: Add more components to the pipeline

client.compile_and_run(pipeline=pipeline)
