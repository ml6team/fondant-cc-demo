"""
Custom component to implement
"""
import dask.dataframe as dd
from fondant.component import TransformComponent


class CustomComponent(TransformComponent):
    """
    Custom component
    """

    def transform(
        self,
        dataframe: dd.DataFrame,
        # *,
        # TODO: Add arguments here
    ) -> dd.DataFrame:
        """
        Implement this function to do the actual filtering

        Args:
            dataframe: Dask dataframe
            Arguments: ...

        Returns:
            Filtered dask dataframe
        """
        # TODO: Add implementation here

        return dataframe


if __name__ == "__main__":
    component = CustomComponent.from_file()
    component.run()
