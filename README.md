# Personality Recognition Demo

<div align="center">
<img src="https://raw.githubusercontent.com/paulvid/perso-detection-demo/master/PERSO_RECOG_DEMO.png">
</div>

## Description

This bundle contains blueprints and recipes necessary for the end to end Personality recognition demo detailed here: https://community.hortonworks.com/articles/214051/news-authors-personality-detection-end-to-end-data.html


## Content Description

This bundle contains the following
- [x] Cluster Blueprint
- [x] Pre-Ambari-Start Metastore Setup
- [x] Nifi Templates & Custom NARs Load
- [x] Zeppelin Notes Load
- [x] HBase Tables Creation
- [x] Kafka Topic Creation
- [x] Schema Registry Load
- [x] SAM App Load
- [x] Custom Dashboard Load

## Install

### Step 1: Dowload git repo
*	git clone https://github.com/paulvid/perso-detection-demo.git

###Step 2: Prepare Cloudbreak
*Load BP bp-perso-detection-demo.json to cloudbreak (call it bp-perso-detection-demo)
*Load all recipes to cloudbreak
**Pre Ambari start: pras-master-perso-detection-demo.sh
**Post  Cluster install: poci-web-server-perso-detection-demo.sh, poci-master-perso-detection-demo.sh, poci-hdf-worker-perso-detection-demo.sh

###Step 3: Launch Cluster
*Run the cli command (do not change password, scripts will fail): 

###Step 4: Launch demo
*Nifi
**Enable all controller services
**Run Personality Recognition + Article Popularity
*Run SAM
**Run application
*Run Zeppelin notebook
**After a few hours of article load, run the note personality_recognition
*Run dashboard
**Go to nifi and run web services processor group
**Go to [IP_OF_THE_EDGE_NODE]
**Connect as admin/admin


## Versions

* Cloudbreak 2.8.0
* HDP 3.0.1
* HDF 3.2

## Authors

* **Paul Vidal** - *Initial work* - [LinkedIn](https://www.linkedin.com/in/paulvid/)