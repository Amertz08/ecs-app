import json

import pytest
from flask import url_for

from app import create_app


@pytest.fixture()
def app():
    return create_app()


def test_index(client):
    response = client.get(url_for("index"))
    assert response.status_code == 200
    assert json.loads(response.data) == {"key": "value"}
