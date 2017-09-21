Save The Galaxy
===============

Just a demo app
---------------

Description
-----------
For this demo I am building a docker image from scratch using Caddy server to serve a static home page.
This application will be deployed on kubernetes. Minikube is used for local dev environment only.
The same templates can be used to generate manifests for production.
Traefik is used LB (for sake of semplicity only http is used), using ingress objects on kubernetes.


What do you need to run this demo on your local environment.
------------------------------------------------------------
- virtualbox
- minikube
- kubectl
- j2cli

Installing dependencies, in case are missing
--------------------------------------------
minikube:

::

    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.21.0/minikube-darwin-amd64 && \
    chmod +x minikube && \
    sudo mv minikube /usr/local/bin/

kubectl:

::

    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl



j2cli:

.. _pip: https://pip.pypa.io/en/stable/installing/#do-i-need-to-install-pip

::

   pip install j2cli[yaml]


Configuration
-------------

If you prefere to use custom settings on this project, just copy configs/*-default-settings.yaml in "configs/*-custom-settings.yaml"
As long as *-custom-settings.yaml is present, the *-default-settings.yaml will be ignored.
::

  cp configs/dev-default-settings.yaml configs/dev-custom-settings.yaml



Usage
-----

First, start minikube:


::

  ./scripts/generate_manifests.sh -e dev


To deploy (-e dev for minikube | -e prod for production):

::

   ./scripts/deploy.sh -e dev

Check everything is up and running:

::

  kubectl get po                                                                                                                                                                                            Thu Sep 21 12:57:44 2017

  NAME                             READY     STATUS    RESTARTS   AGE
  savethegalaxy-3685698123-tfm19   1/1       Running   0          8s


Traefik and others addons are in kube-system namespace

::

  kubectl -n kube-system  get po
  NAME                                  READY     STATUS    RESTARTS   AGE
  kube-addon-manager-minikube           1/1       Running   0          27m
  kube-dns-910330662-9vg5w              3/3       Running   0          23m
  kubernetes-dashboard-86ztr            1/1       Running   0          23m
  traefik-ingress-lb-2517620313-fqzsw   1/1       Running   0          1m

Final test for the demo, edit /etc/hosts putting you ``minikube ip``, in my case is:

::

  192.168.99.100  dev.savethegalaxy.com

Now you can open the browser with http://dev.savethegalaxy.com

Produciton deployement.
-----------------------

Update your custom settings:
::

  cp configs/prod-default-settings.yaml configs/prod-custom-settings.yaml

And go in the same way as for dev, but in this case:
::

  ./scripts/generate_manifests.sh -e prod
  ./scripts/deploy.sh -e prod

Cleaning up (-e dev for minikube | -e prod for production):
-----------------------------------------------------------
::

./scripts/destroy.sh -e dev
