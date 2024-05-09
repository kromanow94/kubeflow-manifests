#!/usr/bin/env python3

# This script is to be run from Kubeflow Notebook
# ```
# pip3 install kfp==2.0.1
# python3 run.test.pipeline.py
# ```

from kfp import dsl
import kfp
from kfp.client.set_volume_credentials import ServiceAccountTokenVolumeCredentials

credentials = ServiceAccountTokenVolumeCredentials()

# Traffic has to go through istio-ingressgateway because the auth mode
# is configured with istioIntegration.authorizationMode=ingressgateway and the
# ml-pipeline-ui AuthorizationPolicy is configured to allow traffic only from
# istioIntegration.ingressGatewayNamespace.
host = "http://istio-ingressgateway.istio-ingress/pipeline"
client = kfp.Client(host=host, credentials=credentials)

experiment_name = "my-experiment"
experiment_namespace = "kubeflow-user-example-com"


@dsl.component
def add(a: float, b: float) -> float:
    """Calculates sum of two arguments"""
    return a + b


@dsl.pipeline(
    name="Addition pipeline",
    description="An example pipeline that performs addition calculations.",
)
def add_pipeline(
    a: float = 1.0,
    b: float = 7.0,
):
    first_add_task = add(a=a, b=4.0)
    second_add_task = add(a=first_add_task.output, b=b)


try:
    print("getting experiment...")
    experiment = client.get_experiment(
        experiment_name=experiment_name, namespace=experiment_namespace
    )
    print("got experiment!")
except Exception:
    print("creating experiment...")
    experiment = client.create_experiment(
        name=experiment_name, namespace=experiment_namespace
    )
    print("created experiment!")

client.create_run_from_pipeline_func(
    add_pipeline,
    arguments={"a": 7.0, "b": 8.0},
    experiment_id=experiment.experiment_id,
    enable_caching=False,
)
