"""
This component filters images of the dataset based on image size (minimum height and width).
"""
import logging

import dask.dataframe as dd

from fondant.component import TransformComponent
from fondant.logger import configure_logging

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
            avg_line_length_threshold: int,
            max_line_length_threshold: int,
            alphanum_fraction_threshold: float
    ) -> dd.DataFrame:
        """
        Args:
            dataframe: Dask dataframe
            avg_line_length_threshold: threshold for average line length to filter on
            max_line_length_threshold: threshold for max line length to filter on
            alphanum_fraction_threshold: alphanum fraction to filter on
        Returns:
            Filtered dask dataframe
        """
        print("columns")
        print(dataframe.columns)
        filtered_df = dataframe[
            (dataframe['texts_avg_line_length'] > avg_line_length_threshold) &
            (dataframe['texts_max_line_length'] > max_line_length_threshold) &
            (dataframe['texts_alphanum_fraction'] > alphanum_fraction_threshold)
            ]

        return filtered_df


if __name__ == "__main__":
    component = FilterMetadataComponent.from_file()
    component.run()
