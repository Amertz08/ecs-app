import paramiko
import pytest


class SSHManager:
    def __init__(self, client: paramiko.SSHClient, pkey: paramiko.RSAKey):
        self.client = client
        self.pkey = pkey

    def __enter__(self):
        return self

    def __call__(self, hostname: str, username: str):
        self.client.connect(
            hostname=hostname, username=username, pkey=self.pkey, timeout=5
        )
        return self.client

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.client.close()


@pytest.fixture()
def ssh_manager(request) -> SSHManager:
    key_path = request.config.getoption("--pem-key-path")
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    pkey = paramiko.RSAKey.from_private_key_file(key_path)
    man = SSHManager(client=client, pkey=pkey)
    return man


def remote_command_exit_code(client: paramiko.SSHClient, cmd: str) -> int:
    chan = client.get_transport().open_session()
    chan.exec_command(cmd)
    exit_code = chan.recv_exit_status()
    return exit_code


def test_can_ssh_into_bastion(bastion_ip, ssh_manager):
    with ssh_manager(hostname=bastion_ip, username="ec2-user") as client:
        exit_code = remote_command_exit_code(client, "ps")
    assert exit_code == 0
