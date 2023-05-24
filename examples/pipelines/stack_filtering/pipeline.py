"""Pipeline used to create a filtered stack dataset using custom components."""
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
pipeline = Pipeline(pipeline_name=pipeline_name, base_path=PipelineConfigs.BASE_PATH)
client = Client(host=PipelineConfigs.HOST)

load_from_hub_op = ComponentOp(
    name="load_from_hub_stack",
    arguments={"dataset_name": "ml6team/the-stack-smol"},
)

your_custom_component_op = ComponentOp(
    name="your_custom_component",  # TODO: rename to the same name of your component
    arguments={},  # TODO: insert your component's arguments here
)

write_to_hub_op = ComponentOp(
    name="write_to_hub_stack",
    arguments={"username": "ml6team",
               "dataset_name": f"{team_name}-the-stack-smol-processed",
               "hf_token": hf_token},
)

pipeline.add_op(load_from_hub_op)
# TODO: Add your component to the pipeline
pipeline.add_op(your_custom_component_op, dependencies=load_from_hub_op)
pipeline.add_op(write_to_hub_op, dependencies=your_custom_component_op)

client.compile_and_run(pipeline=pipeline)
