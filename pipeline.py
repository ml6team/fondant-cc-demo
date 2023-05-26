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

# TODO: add your component here
# your_custom_component_op = ComponentOp(
#     component_spec_path="components/your_custom_component/fondant_component.yaml",
#     arguments={},  # TODO: insert your component's arguments here
# )

pii_redaction_op = ComponentOp(
    component_spec_path="components/pii_redaction/fondant_component.yaml",
)
pipeline.add_op(load_from_hub_op)
# TODO: Add your component op to the pipeline
# pipeline.add_op(comments_filtering_op, dependencies=your_custom_component_op)
pipeline.add_op(pii_redaction_op, dependencies=load_from_hub_op)

client.compile_and_run(pipeline=pipeline)