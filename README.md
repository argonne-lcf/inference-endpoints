# 🤖 ALCF Inference Endpoints

> **Unlock Powerful AI Inference at Argonne Leadership Computing Facility (ALCF)**

For the latest documentation, refer to [ALCF Inference Docs](https://docs.alcf.anl.gov/services/inference-endpoints)


If you use ALCF Inference Endpoints or the Federated Inference Resource Scheduling Toolkit (FIRST) in your research or workflows, please cite our paper:
```bibtex
@inproceedings{10.1145/3731599.3767346,
author = {Tanikanti, Aditya and C\^{o}t\'{e}, Benoit and Guo, Yanfei and Chen, Le and Saint, Nickolaus and Chard, Ryan and Raffenetti, Ken and Thakur, Rajeev and Uram, Thomas and Foster, Ian and Papka, Michael E. and Vishwanath, Venkatram},
title = {FIRST: Federated Inference Resource Scheduling Toolkit for Scientific AI Model Access},
year = {2025},
isbn = {9798400718717},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3731599.3767346},
doi = {10.1145/3731599.3767346},
abstract = {We present the Federated Inference Resource Scheduling Toolkit (FIRST), a framework enabling Inference-as-a-Service across distributed High-Performance Computing (HPC) clusters. FIRST provides cloud-like access to diverse AI models, like Large Language Models (LLMs), on existing HPC infrastructure. Leveraging Globus Auth and Globus Compute, the system allows researchers to run parallel inference workloads via an OpenAI-compliant API on private, secure environments. This cluster-agnostic API allows requests to be distributed across federated clusters, targeting numerous hosted models. FIRST supports multiple inference backends (e.g., vLLM), auto-scales resources, maintains "hot" nodes for low-latency execution, and offers both high-throughput batch and interactive modes. The framework addresses the growing demand for private, secure, and scalable AI inference in scientific workflows, allowing researchers to generate billions of tokens daily on-premises without relying on commercial cloud infrastructure.},
booktitle = {Proceedings of the SC '25 Workshops of the International Conference for High Performance Computing, Networking, Storage and Analysis},
pages = {52–60},
numpages = {9},
keywords = {Inference as a Service, High Performance Computing, Job Schedulers, Large Language Models, Globus, Scientific Computing},
location = {
},
series = {SC Workshops '25}
}
```
