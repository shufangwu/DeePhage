# DeePhage: a tool for identifying phages and plasmids from metagenomic fragments using deep learning

* [Introduction](#introduction)
* [Version](#version)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Output](#output)
* [Citation](#citation)
* [Contact](#contact)
    

## Introduction

DeePhage is designed to identify metavirome sequences as temperate phage-derived and virulent phage-derived sequences. The program calculate a score reflecting the likelihood of each input fragment as temperate phage-derived and virulent phage-derived sequences. DeePhage can run either on the virtual machine or physical host. For non-computer professionals, we recommend running the virtual machine version of DeePhage on local PC. In this way, users do not need to install any dependency package. If GPU is available, you can also choose to run the physical host version. This version can automatically speed up with GPU and is more suitable to handle large scale data. The program is also available at http://cqb.pku.edu.cn/ZhuLab/DeePhage/.

## Version
+ DeePhage 1.0 (Tested on Ubuntu 16.04)

## Requirements
------------
### 1. To run the physical host version of DeePhage, you need to install:
+ [Python 3.6.7](https://www.python.org/)
+ [numpy 1.16.4](http://www.numpy.org/)
+ [h5py 2.9.0](http://www.h5py.org/)
+ [TensorFlow 1.4.0](https://www.tensorflow.org/)
+ [Keras 2.1.3](https://keras.io/)
+ [MATLAB Component Runtime (MCR) R2018a](https://www.mathworks.com/products/compiler/matlab-runtime.html) or [MATLAB R2018a](https://www.mathworks.com/products/matlab.html)

  **Note:**
(1) DeePhage should be run under Linux operating system.
(2) For compatibility, we recommend installing the tools with the similar version as described above.
(3) If GPU is available in your machine, we recommend installing a GPU version of the TensorFlow to speed up the program.
(4) DeePhage can be run with either an executable file or a MATLAB script. If you run DeePhage through the executable file, you need to install the MCR (for free) while MATLAB is not necessary. If you run DeePhage through the MATLAB script, MATLAB is required.

### 2. If you are non-computer professionals who unfamiliar with the Linux operating system, we recommend using the virtual machine of DeePhage. In this way, you do not need to install any dependant packages as mentioned above.



## Installation

### 1. Physical host version
  #### 1.1 Prerequisites
  
  First, please install **numpy, h5py, TensorFlow** and **Keras** according to their manuals. All of these are python packages, which can be installed with ``pip``. If “pip” is not already installed in your machine, use the command “sudo apt-get install python-pip python-dev” to install “pip”. Here are example commands of installing the above python packages using “pip”.
    
    pip install numpy
    pip install h5py
    pip install tensorflow==1.4.0  #CPU version
    pip install tensorflow-gpu==1.4.0  #GPU version
    pip install keras==2.1.3
    
  If you are going to install a GPU version of the TensorFlow, specified NVIDIA software should be installed. See https://www.tensorflow.org/install/install_linux to know whether your machine can install TensorFlow with GPU support.  
  
  When running DeePhage through the executable file, MCR should be installed. See https://www.mathworks.com/help/compiler/install-the-matlab-runtime.html to install MCR. On the target computer, please append the following to your LD_LIBRARY_PATH environment variable according to the tips of MCR:
  
    <MCR_installation_folder>/v94/runtime/glnxa64
    <MCR_installation_folder>/v94/bin/glnxa64
    <MCR_installation_folder>/v94/sys/os/glnxa64
    <MCR_installation_folder>/v94/extern/bin/glnxa64
    
  When  running  DeePhage  through  the MATLAB script, please  see https://www.mathworks.com/support/ to install the MATLAB.  
  
  #### 1.2 Install DeePhage using git
  
  Clone DeePhage package
  
    git clone https://github.com/shufangwu/DeePhage.git
    
  Change directory to DeePhage:
  
    cd DeePhage
    
  The executable file and all scripts are under the folder
  
  #### 1.3 Install DeePhage from zipped file
  
  DeePhage can also download as a zipped file:
  
    wget http://cqb.pku.edu.cn/ZhuLab/DeePhage/DeePhage_v_1_0.zip
    
  Unpack the zipped file:
  
    unzip DeePhage_v_1_0.zip
    
  Change directory to DeePhage
  
    cd DeePhage_v_1_0
    
  The executable file and all scripts are under the folder
  
### 2. Virtual machine version

The installation of the virtual machine is much easier. Please refer to [Manual.pdf](http://cqb.pku.edu.cn/ZhuLab/DeePhage/Manual.pdf) for a step by step guide with screenshot to see how to install the vertual machine. 

## Usage

### 1. Run DeePhage using executable file (in command line)

  Please simply execute the command:
  
    ./DeePhage <input_file_folder>/input_file.fna <output_file_folder>/output_file.csv
    
  The input file must be in fasta format containing the sequences to be identified. For example, users can use the file "example.fna" in the folder to test DeePhage by simply executing the command:
  
    ./DeePhage example.fna result.csv
    
### 2. Run DeePhage using MATLAB script (in MATLAB GUI)

  Please execute the following command directly in MATLAB command window:
  
    DeePhage('<input_file_folder>/input_file.fna','<output_file_folder>/output_file.csv')
    
  For example, if you want to identify the sequences in "example.fna", please execute:
  
    DeePhage('example.fna','result.csv')
    
  Please remember to set the working path of MATLAB to DeePhage folder before running the programe.
  
### 3. Run DeePhage with specified threshold

  For each input sequence, DeePhage will output one scores (between 0 to 1), representing the lifestyle prediction score. The sequence with a score higher than 0.5 would be regarded as a virulent phage-derived fragment and the sequence with a score lower than 0.5 would be regarded as a temperate phage-derived fragment. Users can also specify a threshold. In this way, a sequence with a score between (0.5-threshold, 0.5+threshold) will be labelled as "uncertain". In general, with a higher threshold, the percentage of uncertain predictions will be higher while the remaining predictions will be more reliable. For example, if you want to get relatively reliable predictions in the file “example.fna”, you can take 0.3 as the threshold. Please execute:
  
    ./DeePhage example.fna result.csv 0.7 (by executable file)
    or
    DeePhage('example.fna','result.csv','0.7') (by MATLAB script)
    
### 4. Run DeePhage in virtual machine

  We recommend that non-computer professionals run DeePhage in this way. The virtual machine version of PPR-DeePhage run through the executable file (see item 1 above). Please refer to [Manual.pdf](http://cqb.pku.edu.cn/ZhuLab/DeePhage/Manual.pdf). 
  
## Output

The output of DeePhage consists of four columns:

Header | Length | lifestyle_score | possible_lifestyle 
------ | ------ | ----------- | ---------------- |

The content in `Header` column is the same with the header of corresponding sequence in the input file. The possible lifestyle is the the possible lifestyle of the sequence. If DeePhage is executed under specified threshold, the sequence with the highest score lower than the threshold will be label as uncertain in `possible_lifestyle` columns.

**Note:**
(1) The current version of DeePhage uses “comma-separated values (CSV)” as the format of the output file. Please use “.csv” as the extension of the output file. DeePhage will automatically add the “.csv” extension to the file name if the output file does not take “.csv” as its extension”.
(2) If you want to run multiple tasks at the same time (either on physical host or virtual machine), please copy DeePhage package into different folders and run different tasks under different folders. Do not run different tasks under the same folder.


# Citation
Shufang Wu, Zhencheng Fang, Jie Tan,..., and Huaiqiu Zhu. DeePhage: distinguish temperate phage-derived and virulent phage-derived sequence in metavirome data using deep learning. 

# Contact
Any question, please do not hesitate to contact me: wu-shufang@pku.edu.cn
