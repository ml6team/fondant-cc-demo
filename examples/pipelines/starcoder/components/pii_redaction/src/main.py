"""A component that redacts Personal Identifiable Information (PII) from code."""

import logging

import dask.dataframe as dd

from fondant.component import TransformComponent
from fondant.logger import configure_logging

configure_logging()
logger = logging.getLogger(__name__)


class RedactPIIComponent(TransformComponent):
    """
    Component that redacts PII from code.
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
    component = RedactPIIComponent.from_file()
    component.run()