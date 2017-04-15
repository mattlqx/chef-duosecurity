# duosecurity Cookbook
====================

Installs and configures either
[login_duo](https://duo.com/docs/loginunix) or
[pam_duo](https://duo.com/docs/duounix) depending on the attribute
settings.

You will need to configure sshd to make use of it. See the upstream
docs for information.

## Attributes

- `node["duosecurity"]["integration_key"]` - Required. Integration key, recommended to set from an encrypted value.
- `node["duosecurity"]["secret_key"]` - Required. Secret key, recommended to set from an encrypted value.
- `node["duosecurity"]["api_hostname"]` - Required. API hostname for your Duo account.
- `node["duosecurity"]["groups"]` - Optional. If specified, Duo authentication is required only for users whose primary group or supplementary group list matches one of the space-separated pattern lists.
- `node["duosecurity"]["failmode"]` - Optional. On service or configuration errors that prevent Duo authentication, fail "safe" (allow access) or "secure" (deny access). The default is "safe".
- `node["duosecurity"]["pushinfo"]` - Optional. Include information such as the command to be executed in the Duo Push message. Either "yes" or "no". The default is "no".
- `node["duosecurity"]["http_proxy"]` - Optional. Use the specified HTTP proxy, same format as the `HTTP_PROXY` environment variable. (honored by wget, curl, etc.).
- `node["duosecurity"]["autopush"]` - Optional. Either "yes" or "no". Default is "no". If "yes", Duo Unix will automatically send a push login request to the user's phone, falling back on a phone call if push is unavailable. If "no", the user will be prompted to choose an authentication method. When configured with `autopush = yes`, we recommend setting `prompts = 1`.
- `node["duosecurity"]["motd"]` - Optional. Print the contents of `/etc/motd` to screen after a successful login. Either "yes" or "no". The default is "no". This option is only available for login_duo.
- `node["duosecurity"]["prompts"]` - Optional. If a user fails to authenticate with a second factor, Duo Unix will prompt the user to authenticate again. This option sets the maximum number of prompts that Duo Unix will display before denying access. Must be 1, 2, or 3. Default is 3. For example, when prompts = 1, the user will have to successfully authenticate on the first prompt, whereas if prompts = 2, if the user enters incorrect information at the initial prompt, he/she will be prompted to authenticate again. When configured with `autopush = yes`, we recommend setting prompts = 1.
- `node["duosecurity"]["accept_env_factor"]` - Optional. Look for factor selection or passcode in the `$DUO_PASSCODE` environment variable before prompting the user for input. When `$DUO_PASSCODE` is non-empty, it will override autopush. The SSH client will need `SendEnv DUO_PASSCODE` in its configuration, and the SSH server will similarily need `AcceptEnv DUO_PASSCODE`. Default is "no".
- `node["duosecurity"]["fallback_local_ip"]` - Optional. Duo Unix reports the IP address of the authorizing user, for the purposes of authorization and whitelisting. If Duo Unix cannot detect the IP address of the client, setting `fallback_local_ip = yes` will cause Duo Unix to send the IP address of the server it is running on. If you are using IP whitelisting, enabling this option could cause unauthorized logins if the local IP is listed in the whitelist.
- `node["duosecurity"]["https_timeout"]` - Optional. Set to the number of seconds to wait for HTTPS responses from Duo Security. If Duo Security takes longer than the configured number of seconds to respond to the preauth API call, the configured failmode is triggered. Other network operations such as DNS resolution, TCP connection establishment, and the SSL handshake have their own independent timeout and retry logic. Default is 0, which disables the HTTPS timeout.
- `node["duosecurity"]["install_type"]` - Optional. Either "source" or "package". Defaults to "source" which will compile from source code and requires a working compiler (not managed by this cookbook).
- `node["duosecurity"]["use_pam"]` - Optional. Either "yes" or "no". Default is "no". If "yes", Duo Unix will be setup as a pam module and ssh will be configured to use it rather than the `login_duo` binary. Requires OpenSSH 6.2+.
- `node["duosecurity"]["protect_sudo"]` - Optional. Either "yes" or "no". Default is "no". If "yes", then Duo two-factor authentication will be used for the sudo command if `use_pam` is also `yes`.
- `node["duosecurity"]["use_duo_repo"]` - Optional. Either "yes" or "no". Default is "no". If "yes", the duosecurity.com apt repo will be added and latest version from the repo will be preferred if `install_type` is set to `package`.
- `node["duosecurity"]["first_factor"]` - Optional. Either "pubkey", "password" or undefined. `pubkey` will alter sshd configuration to use public key auth as first factor. `password` will alter sshd configuration to use password as first factor. Leaving undefined will not set default ssh authentication configuration. Requires `use_pam` to be `yes`.
- `node["duosecurity"]["apt"]["keyserver"]` - Optional. Override the default keyserver for the duosecurity.com APT repository signing key.
