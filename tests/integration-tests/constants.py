# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with
# the License. A copy of the License is located at
#
# http://aws.amazon.com/apache2.0/
#
# or in the "LICENSE.txt" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions and
# limitations under the License.
from enum import Enum

SCHEDULERS_SUPPORTING_IMDS_SECURED = ["slurm"]

OSU_BENCHMARK_VERSION = "7.0-lrbison3"


class NodeType(Enum):
    """Categories of nodes."""

    HEAD_NODE = "HeadNode"
    LOGIN_NODES = "LoginNodes"
    COMPUTE_NODES = "ComputeNodes"
