# fondant-cc-demo

## Install requirements

This will install Fondant from PyPI
```commandline
pip install -r requirements.txt
```

## Explore the data using the provided notebook

Start the Jupyter notebook server
```commandline
jupyter notebook
```

## Write your custom component

We have provided some boilerplate for you to get started in `components/custom_component`.

### Rename your component

- The name of the directory originally called `custom_component`. The build script will 
  automatically use this to name the image of your component
- The `CustomComponent` class in `components/custom_component/src/main.py`
- In `components/custom_component/fondant_component.yaml`

### Define your component interface

Just as we develop our APIs spec-first, you should do the same for your Fondant component.

Head over to `components/custom_component/fondant_component.yaml` and specify:
- Which fields of the data you want to access
- Which arguments your component accepts

Fondant will use this information to call your component's `transform` method

### Implement your component

Implement your component by implementing the `transform` 
method in `components/custom_component/src/main.py`.

### Testing your component

We provided a small script to test your component locally. In the future, Fondant will provide 
this functionality built-in.

Go to your component directory
```commandline
cd components/custom_component
```

Install the requirements.txt
```commandline
pip install -r requirements.txt
```

And run the script
```commandline
./run_locally.sh
```

You will have to add any arguments your component takes to the script as well.

### Building your component

Before you can use your component in your pipeline, you need to build its docker image

If you're not there yet, go to your component directory
```commandline
cd components/custom_component
```

And run the script
```commandline
./build_image.sh
```

### Add your component to your pipeline

Now you can add your component to your pipeline in `pipeline.py`

**Make sure to update your pipeline name!**

### Running your pipeline

You can now run your pipeline by moving back to the root directory and running:
```commandline
python pipeline.py
```

You should see a url in your terminal which brings you to your running pipeline.

### Validating your results

Go back to your notebook to validate the results from your pipeline