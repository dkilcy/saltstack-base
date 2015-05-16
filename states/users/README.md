
### users

Configures root user environment and users listed in the `users_list` pillar.

- Creates a colorful prompt for root user
- Installs .vimrc from `vim` state
- For each user in the users_list pillar value:
  - creates the user and sets the default shell
  - adds the user to the sudoers list so it can execute a command as root without a password
  - creates the authorized_keys file using the public key defined in the pillar
  - Installs .vimrc from `vim` state
  - Creates a colorful prompt for the user
  
  
