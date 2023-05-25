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
    component_spec_path="components/load_from_hub_stack/fondant_component.yaml",
    arguments={"dataset_name": "ml6team/the-stack-smol-python"},
)
filter_metadata_op = ComponentOp(
    component_spec_path="components/filter_metadata/fondant_component.yaml",
    arguments={
        "avg_line_length_threshold": 10,
        "max_line_length_threshold": 100,
        "alphanum_fraction_threshold": 0.25
    }
)
comments_filtering_op = ComponentOp(
    component_spec_path="components/comments_filtering/fondant_component.yaml",
    arguments={
        "min_comments_ratio": 0.1,
        "max_comments_ratio": 0.9
    }
)
# TODO: add more components
# your_custom_component_op = ComponentOp(
#     component_spec_path="components/your_custom_component/fondant_component.yaml",
#     arguments={},  # TODO: insert your component's arguments here
# )

pii_redaction_op = ComponentOp(
    component_spec_path="components/pii_redaction/fondant_component.yaml",
)
pipeline.add_op(load_from_hub_op)
pipeline.add_op(filter_metadata_op, dependencies=load_from_hub_op)
pipeline.add_op(comments_filtering_op, dependencies=filter_metadata_op)
# TODO: Add more components to the pipeline
# pipeline.add_op(comments_filtering_op, dependencies=your_custom_component_op)
pipeline.add_op(pii_redaction_op, dependencies=load_from_hub_op)

client.compile_and_run(pipeline=pipeline)
