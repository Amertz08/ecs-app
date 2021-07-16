def pytest_addoption(parser):
    # TODO: just use a config file
    parser.addoption("--pem-key-path")
    parser.addoption("--bastion-ips", action="append")


def pytest_generate_tests(metafunc):
    if "bastion_ip" in metafunc.fixturenames:
        ip_addresses = metafunc.config.getoption("bastion_ips")
        metafunc.parametrize("bastion_ip", ip_addresses)
