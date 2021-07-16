import paramiko
import pytest


@pytest.fixture()
def pem_key(request):
    key_path = request.config.getoption("--pem-key-path")
    return paramiko.RSAKey.from_private_key_file(key_path)


@pytest.fixture()
def ssh_client():
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    return client


def remote_command_exit_code(client: paramiko.SSHClient, cmd: str) -> int:
    chan = client.get_transport().open_session()
    chan.exec_command(cmd)
    exit_code = chan.recv_exit_status()
    return exit_code


def test_can_ssh_into_bastion(bastion_ip, ssh_client, pem_key):

    ssh_client.connect(hostname=bastion_ip, username="ec2-user", pkey=pem_key)
    try:
        exit_code = remote_command_exit_code(ssh_client, "ps")
    finally:
        ssh_client.close()

    assert exit_code == 0
