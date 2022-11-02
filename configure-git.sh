echo "Configuring Git"

#  Install Git
if [ -x "$(command -v git)" ]; then
    echo "✔️ git installed"
else
    echo "Installing git..."
    brew install git
fi;

echo "Github requires a few global settings to be configured"

echo "Checking git config ..."
# if git config --global user.email is not set, then set it
if [ -z "$(git config --global user.email)" ]; then
    echo "Enter the email address associated with your GitHub account: "
    read -r email
    git config --global user.email "$email"
else 
    # print warning in yellow if email is already set
    echo "\033[0;33mWARNING: git config --global user.email is already set to $(git config --global user.email)\033[0m"
fi;

# if git config --global user.name is not set, then set it
if [ -z "$(git config --global user.name)" ]; then
    echo "Enter your full name (Ex. John Doe): "
    read -r username
    git config --global user.name "$username"
else 
    # print warning in orange if name is already set
    echo "\033[0;33mWarning: git config --global user.name is already set to $(git config --global user.name)\033[0m"
fi;

echo "Your git config is now set to:"
echo "\n\n"
# print git config in green
echo "\033[0;32m$(git config --list)\033[0m"
echo "\n\n"

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$email"
fi;

echo "Copying your SSH key to your clipboard"
pbcopy < ~/.ssh/id_rsa.pub
sleep 1
echo "Add the generated SSH key to your GitHub account. It has been copied to your clipboard"
echo "https://github.com/settings/keys"