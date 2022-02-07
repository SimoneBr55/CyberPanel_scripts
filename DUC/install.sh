#!/bin/bash

echo "HAVE YOU SETUP <.set_env_vars> FILE?"
read

sudo mkdir /etc/DUC
cp .set_env_vars /etc/DUC/

echo "DONE"
