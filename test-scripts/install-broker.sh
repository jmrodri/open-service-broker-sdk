#!/bin/sh -e

targetNamespace=brokersdk

# Installer creates namespace of its choice
oc new-project ${targetNamespace}

# Installer creates `brokersdk` service
oc create -f resources/service.yaml

# Installer creates `brokersdk` service account
oc create -f resources/sa.yaml


# Installer binds “known” roles to SA user
oc create -f resources/roles.yaml || true

oc adm policy add-cluster-role-to-user system:auth-delegator -n ${targetNamespace} system:serviceaccount:${targetNamespace}:brokersdk
oc create policybinding kube-system -n kube-system
oc adm policy add-role-to-user extension-apiserver-authentication-reader -n kube-system --role-namespace=kube-system system:serviceaccount:${targetNamespace}:brokersdk

# Create the brokersdk replication controller
oc create -f resources/rc.yaml
