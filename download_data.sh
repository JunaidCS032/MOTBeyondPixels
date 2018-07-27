#!/bin/bash

./third_party/gdown.pl https://drive.google.com/open?id=1X7oREQk4qE8z3po3vACZ4FKxPcWJF43A

cd data
tar -zxvf calib.tar.gz
tar -zxvf Features2D_mat.tar.gz
tar -zxvf images.tar.gz
tar -zxvf ORBSLAM_pose.tar.gz
tar -zxvf RRC_Detections_mat.tar.gz
tar -zxvf RRC_Detections_txt.tar.gz

rm calib.tar.gz
rm Features2D_mat.tar.gz
rm images.tar.gz
rm ORBSLAM_pose.tar.gz
rm RRC_Detections_mat.tar.gz
rm RRC_Detections_txt.tar.gz


