OH_MY_ZSH_CONFIG=~/.oh-my-zsh/oh-my-zsh.sh
if test -f "$OH_MY_ZSH_CONFIG"; then
  echo "\033[0;32m✔️ ZSH configured\033[0m"
else
  # Begin oh my zsh setup
  # Pretty, minimal shell with a couple useful plugins
  echo "Configuring Oh My ZSH"
  { # your 'try' block
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  } || { # your 'catch' block
      echo 'Oh My Zsh like to exit for some reasons so this prevents it'
  }

  # Configure ZSH  plugins
  echo "Configuring ZSH plugins"
  {
      git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
      git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
      sed -i .bak 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
  } || {
      echo 'Failed to configure zsh plugins'
  }
fi;
# End oh my zsh setup