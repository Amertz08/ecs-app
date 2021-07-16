import paramiko
import pytest


class SSHManager:
    def __init__(self):
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    def __enter__(self):
        return self

    def __call__(self, hostname: str, username: str, pkey: paramiko.RSAKey):
        self.client.connect(hostname=hostname, username=username, pkey=pkey, timeout=5)

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.client.close()


@pytest.fixture()
def pem_key(request):
    key_path = request.config.getoption("--pem-key-path")
    return paramiko.RSAKey.from_private_key_file(key_path)


@pytest.fixture()
def ssh_manager() -> SSHManager:
    man = SSHManager()
    return man


def remote_command_exit_code(client: paramiko.SSHClient, cmd: str) -> int:
    chan = client.get_transport().open_session()
    chan.exec_command(cmd)
    exit_code = chan.recv_exit_status()
    return exit_code


def test_can_ssh_into_bastion(bastion_ip, ssh_manager, pem_key):

    with ssh_manager(hostname=bastion_ip, username="ec2-user", pkey=pem_key) as client:
        exit_code = remote_command_exit_code(client, "ps")
    assert exit_code == 0
