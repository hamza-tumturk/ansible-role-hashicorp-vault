Role Name
=========

Ansible Role to install and configure a Hashicorp Vault Server.
This Role does not initialize the Vault Storage Backend. It needs to be done manually. See section Initializing.

Role Variables
--------------

    vault_version: 0.7.3
    vault_artefact_url: "https://releases.hashicorp.com/vault/{{ vault_version }}"
    vault_versions:
      0.7.0:
        url: "{{ vault_artefact_url }}/vault_0.7.0_linux_amd64.zip"
        sha256: c6d97220e75335f75bd6f603bb23f1f16fe8e2a9d850ba59599b1a0e4d067aaa
      0.7.3:
        url: "{{ vault_artefact_url }}/vault_0.7.3_linux_amd64.zip"
        sha256: 2822164d5dd347debae8b3370f73f9564a037fc18e9adcabca5907201e5aab45
    
    vault_bin_dir: /opt/vault
    vault_cache_dir: /var/cache/vault
    vault_user: vault
    vault_group: vault
    vault_addr: "http://127.0.0.1:8200" # Environment set in profiles for vault client

    
Vault configuration - check official documentation for parameters:
https://www.vaultproject.io/docs/configuration/index.html
    
    # Vault configuration parameters
    vault_config_params:
      - cluster_name: "vault-cluster"
      - default_lease_ttl: "768h"
      - max_lease_ttl: "768h"
    
    # Vault listener parameters
    vault_config_listener_params:
      http:
        - address: "0.0.0.0:8200"
        - tls_disable: true
    
    # Vault storage backend
    vault_config_storage: file
    vault_config_storage_params:
      - path: "/var/vault"
    
    # Vault telemetry parameters
    vault_config_telemetry_params:
      - statsite_address: "127.0.0.1:8125"

    # Vault backends
    vault_secret_backends: []
    vault_system_backends: []
    vault_auth_backends: []
    # Use these with following options:
     - path: "/path/backend"
       method: PUT
       parameters:
         option1: "key123"
         parameter2: "param456"

Example Playbook
----------------
    - hosts: all
      roles:
        - role: ansible-role-hashicorp-vault
          tasks_to_run:
            - install
            - init
            - config # requires unsealing vault

Initializing
------------
Initialization is the process of first configuring the Vault. This only happens once when the server is started against a new backend that has never been used with Vault before.
Either use CLI on the Vault Server:

    vault init -address=http://vault.domain.xz:8200

or by API interaction:

    curl \
      -X PUT \
      -d "{\"secret_shares\":1, \"secret_threshold\":1}" \
      http://vault.domain.xz:8200/v1/sys/init

**Initialization outputs two incredibly important pieces of information: the unseal keys and the initial root token. This is the only time ever that all of this data is known by Vault, and also the only time that the unseal keys should ever be so close together.
SAVE ALL OF THESE KEYS SOMEWHERE**

License
-------

BSD

Author Information
------------------
Hamza Tumturk
