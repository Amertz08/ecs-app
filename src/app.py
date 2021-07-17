from flask import Flask


def create_app():
    app = Flask(__name__)
    import views

    app.add_url_rule("/", view_func=views.IndexView.as_view("index"))
    return app
