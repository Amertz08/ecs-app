from flask import jsonify
from flask.views import MethodView


class IndexView(MethodView):
    def get(self):
        return jsonify({"key": "value"})
