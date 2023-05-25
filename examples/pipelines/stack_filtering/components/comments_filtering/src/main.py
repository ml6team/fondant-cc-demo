"""
This component filters images of the dataset based on image size (minimum height and width).
"""
import logging

import dask.dataframe as dd
from fondant.component import TransformComponent
from fondant.logger import configure_logging

from utils.text_extraction import get_comments_to_code_ratio

configure_logging()
logger = logging.getLogger(__name__)


class FilterMetadataComponent(TransformComponent):
    """
    Component that filters images based on height and width.
    """

    def transform(
            self,
            *,
            dataframe: dd.DataFrame,
            min_comments_ratio: float,
            max_comments_ratio: float
    ) -> dd.DataFrame:
        """
        Args:
            dataframe: Dask dataframe
            min_comments_ratio: The minimum code to comment ratio
            max_comments_ratio: The maximum code to comment ratio
        Returns:
            Filtered dask dataframe
        """

        # Apply the function to the desired column and filter the DataFrame
        filtered_df = dataframe[
            dataframe['texts_content']
            .map_partitions(lambda example: example.map(get_comments_to_code_ratio)
            .between(min_comments_ratio, max_comments_ratio))
        ]

        return filtered_df


if __name__ == "__main__":
    component = FilterMetadataComponent.from_file()
    component.run()
