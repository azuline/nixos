#!/usr/bin/env bash

wg show interfaces | sed 's/ / • /g'
