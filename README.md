# onboard

automate your developer onboarding.

this particular example is for installing on Mac, but the same can be done for different OS's as well.

Run the onboard script with `curl | sh`

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/master/onboard.sh)"
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

See script to see included tools.

## Additional useful scripts

As well as install tools, it can be useful to make sure things like, the AWS CLI, for example, are configured the same way on each dev's machine for ease of writing scripts.

### Configure AWS Profile

> First, make sure `AWS_PROFILE` is set to something unique to your org name, such as "cne", by default this is undefined, as it will be different for each org. If you're the first person to clone this template, set this value so the rest of your team will not have to.
> First, make sure `AWS_REGION` is set to which AWS Region you use, such as `us-west-2`

Get your AWS credentials from an AWS administrator, then run:

```
AWS_ACCESS_KEY_ID=<paste aws-access-key-id> AWS_SECRET_ACCESS_KEY=<paste aws-secret-access-key> make configure-aws-cli
```

This will modify or create your `~/.aws/config` and `~/.aws/credentials` files to create an `AWS_PROFILE` with the name defined in the `Makefile`

Any time you want to work with the project - for example to get build logs, you need to "login" by setting this `AWS_PROFILE` environment variable in your shell.

For example, if you chose the profile name "cne"
```
export AWS_PROFILE=cne
```

Future scripts can then expect this AWS profile to exist.

### Join an EKS cluster

This is actually a single command using the AWS Cli, however, it's not something that most people remember, so I included it here for simplicity.

> Make sure `AWS_REGION` is set to which AWS Region you use, such as `us-west-2`
> Set the value of `EKS_CLUSTER_NAME` to the name of your EKS cluster

Then run `make onboard-eks-cluster`
