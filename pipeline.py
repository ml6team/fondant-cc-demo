"""Pipeline used to create the dataset to train the StarCoder model."""

import logging

from fondant.logger import configure_logging
from fondant.pipeline import ComponentOp, Pipeline, Client
from pipeline_config import PipelineConfig

configure_logging()
logger = logging.getLogger(__name__)

# Pipeline description
team_name = "cheesecake"  # TODO: insert your team name
pipeline_name = f"Stack filtering pipeline {team_name}"
pipeline_description = "A pipeline for filtering the stack dataset"

# Initialize pipeline and client
pipeline = Pipeline(
    pipeline_name=pipeline_name,
    pipeline_description=pipeline_description,
    base_path=PipelineConfig.BASE_PATH,
)
client = Client(host=PipelineConfig.HOST)

load_from_hub_op = ComponentOp(
    component_spec_path="components/load_from_hub_stack/fondant_component.yaml",
    arguments={"dataset_name": "ml6team/the-stack-smol-python"},
)
filter_metadata_op = ComponentOp(
    component_spec_path="components/filter_metadata/fondant_component.yaml",
    arguments={
        "avg_line_length_threshold": 10,
        "max_line_length_threshold": 100,
        "alphanum_fraction_threshold": 0.25,
    },
)
comments_filtering_op = ComponentOp(
    component_spec_path="components/comments_filtering/fondant_component.yaml",
    arguments={"min_comments_ratio": 0.1, "max_comments_ratio": 0.9},
)
# TODO: Add your custom component op
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
# TODO: Add your custom component to the pipeline
pipeline.add_op(pii_redaction_op, dependencies=load_from_hub_op)

client.compile_and_run(pipeline=pipeline)
