OS := $(shell uname)
AWS_REGION ?=
AWS_PROFILE ?=
AWS_ACCESS_KEY_ID ?=
AWS_SECRET_ACCESS_KEY ?=
EKS_CLUSTER_NAME ?=

configure-aws-cli:
ifndef AWS_PROFILE
	$(error Error: AWS_PROFILE is undefined. Please re-run the command with AWS_PROFILE in your environment. )
endif
ifndef AWS_REGION
	$(error Error: AWS_REGION is undefined. Please re-run the command with AWS_REGION in your environment. )
endif
ifndef AWS_ACCESS_KEY_ID
	$(error Error: AWS_ACCESS_KEY_ID is undefined. Please re-run the command with AWS_ACCESS_KEY_ID in your environment. )
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error Error: AWS_SECRET_ACCESS_KEY is undefined. Please re-run the command with AWS_SECRET_ACCESS_KEY in your environment. )
endif
	AWS_PROFILE=$(AWS_PROFILE) \
	AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
	AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
	./configure-aws-profile.sh

onboard-eks-cluster:
ifndef AWS_PROFILE
	$(error Error: AWS_PROFILE is undefined. Please re-run the command with AWS_PROFILE in your environment. )
endif
ifndef AWS_REGION
	$(error Error: AWS_REGION is undefined. Please re-run the command with AWS_REGION in your environment. )
endif
ifndef EKS_CLUSTER_NAME
	$(error Error: EKS_CLUSTER_NAME is undefined. Please re-run the command with EKS_CLUSTER_NAME in your environment. )
endif
	AWS_PROFILE=$(AWS_PROFILE) aws eks --region $(AWS_REGION) update-kubeconfig --name $(EKS_CLUSTER_NAME)
