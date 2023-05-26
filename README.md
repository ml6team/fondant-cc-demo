# fondant-cc-demo

The goal of this demo is get yourself familiar with the Fondant framework.

In this demo, we'll be building a simple data preparation pipeline for a code assistant (like [StarCoder](https://huggingface.co/blog/starcoder) or [Github CoPilot](https://github.com/features/copilot)).

The pipeline consists of 3 components. We already implemented 2 of them, it's up to you to implement the one in the middle.

The first component loads a code dataset from the 🤗 [hub](https://huggingface.co/), the next component filters this dataset (based on a metric of your choice, like number of lines of code) and the final component removes PII (Personal Identifiable Information) from the code.

This way, we end up with a higher quality, anonymized dataset on which we can train a language model.

<img width="900" alt="Screenshot 2023-05-26 at 09 31 09" src="https://github.com/ml6team/fondant-cc-demo/assets/48327001/387ae2ff-27e2-400b-93fd-f55096854749">

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
