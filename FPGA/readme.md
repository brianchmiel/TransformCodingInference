## FPGA Implementation



This folder contains the FPGA VHDL code used to test the resource needed to implement the PCA 

compression algorithm.


# Folder Structure

Each folder contains the complete project that was created in Quartus Prime Pro version 17.1.




# Block Diagram

Each convolotion layer was created seperatly. The block diagram for the 64 concolution layer: 

![results](docs/block_diagram.png)

We have implemented the part that is inside the yellow frame. The goal is to verify the PCA 
algorithm, so we only care about the amount of data that will be read and written to the DDR. 






