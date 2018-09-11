# gcp-enable-ssh
Use:  modify script to fit your needs,   will have to at least set the network/vpc name

Purpose:

  Enable 

  cloud shell gcloud ssh 

  and 

  google cloud console ssh in browser 

  features to function 


  in secure environments



More Info:

By default when creating a project, the default VPC is created and creates default firewall rules.

It is advised to not use the default VPC and firewall rules as the default rules allow the world to ping, ssh and rdp your servers in GCP.

When removing the default rules for SSH, many have found that features they use in the Google Cloud Console no longer fuction as expected.   Google has documented this at the following link.


Source: https://cloud.google.com/compute/docs/ssh-in-browser#ssherror

Excerpt:

The firewall rule allowing SSH access is enabled, but is not configured to allow connections from GCP Console services. Source IP addresses for browser-based SSH sessions are dynamically allocated by GCP Console and can vary from session to session. For the feature to work, you must allow connections either from any IP address or from Google's IP address range which you can retrieve using public SPF records.
