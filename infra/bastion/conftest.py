def pytest_addoption(parser):
    parser.addoption("--pem-key-path")
    parser.addini("bastion_ips", type="linelist", help="Bastion IP addresses")


def pytest_generate_tests(metafunc):
    if "bastion_ip" in metafunc.fixturenames:
        ip_addresses = metafunc.config.getini("bastion_ips")
        metafunc.parametrize("bastion_ip", ip_addresses)
