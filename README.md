# onboard

automate your developer onboarding.

this particular example is for installing on Mac, but the same can be done for different OS's as well.

Run the onboard script with `curl | sh`

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/main/onboard.sh)"
```

OR, run `git clone` this repo, and run the script with

```
sh ./onboard.sh
```

After running the onboard script, restart your shell, or run `source ~/.zshrc` to get updated ZSH profile

# Install Development Tools

The required development tools will be installed using the general heuristic of first checking whether or not a command is callable from your machine, and if not, installing that tool by running the preferred install commands, generally found in each product's documentation.

For example, if you want to ensure that `docker` is installed:

```sh
if [ -x "$(command -v docker)" ]; then
    echo "✔️ docker installed"
else
    brew install docker
fi;
```
