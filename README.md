SDR Analytics

This is the main binary package for SDR Analytics. 

SystemDataRecorder contains two main modules: the recording and the analytics or the reporting module. They can work independently of each-other, having the recording module alone or together coupled with the reporting module. In addition, if your recorded data comes from different collectors than SDR, you can feed the raw data into reporting module.

The reporting module, consists of several key technologies: a non-relational database system, Perl, R Statistical, PDQ analytical solver all running on top of a HTTP server. Additional tools help us to better visualize our workload(s), and measure them in order to conclude if we have the correct computer infrastructure. The reporting engine deploys simple scripts used to fetch, analyse and generate reports. This way, the SDR Reporting contains several sub-modules:

## Reporting Kernel
Built on top of Perl, R, RRDtool and NGINX contains two main sub-modules: data input layer, responsible to handle all incoming data from all active hosts and data processin layer, managing all data analysis, plotting and reporting part. These two sub-modules can operate independently of each other. The kernel as well if offering a minimal API to export to the other consumers, via JSON, all aggregated data over HTTP or HTTPS. 

## Data Visualization Engines

