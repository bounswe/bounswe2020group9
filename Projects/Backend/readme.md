## How to install and run the app:

### Assuming you have installed python and downloaded the repository already

1. change your directory to `<REPOSITORY>\Projects\Backend`
2. install virtual envioronment using `python -m venv venv`
3. activate the virtual environment using `.\venv\Scripts\Activate` (for Windows) or `source mypython/bin/activate`(for Mac OS / Linux)
4. install the required packages using `pip install -r requirements text`

You should be able to run the project now. To do so, use:

```
cd ./api
python manage.py runserver
```

**Do not forget to** add required packages into requirements.txt. To do so, use:

```
pip freeze > requirements.txt
```

Good luck on the project