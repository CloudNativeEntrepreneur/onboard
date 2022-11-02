# Other Mac Apps
if [ -x "$(command -v code)" ]; then
    echo "\033[0;32m✔️ VS Code installed\033[0m"
else
    brew install --cask visual-studio-code        
fi;

# ask if user wants to install extensions
echo "Would you like to install VS Code extensions? (y/n)"
read -r installExtensions

# if user wants to install extensions, then install them
if [ "$installExtensions" = "y" ]; then
    echo "Installing VS Code extensions..."
    code --install-extension redhat.vscode-knative 
    code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools 
    code --install-extension GitHub.copilot 
    code --install-extension GitHub.vscode-pull-request-github 
    code --install-extension ms-azuretools.vscode-docker 
    code --install-extension mikestead.dotenv 
    code --install-extension hashicorp.terraform 
    code --install-extension oderwat.indent-rainbow 
    code --install-extension ms-vscode.makefile-tools 
    code --install-extension svelte.svelte-vscode 
    code --install-extension redhat.vscode-yaml 
    code --install-extension mujichOk.vscode-project-name-in-statusbar
fi
