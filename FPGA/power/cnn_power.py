#!/usr/bin/python

from sys import argv

def calc_power(entropy_in, entropy_out, input_feature_size, output_feature_size, design_power, fpga_frequency, calculation_clocks):
    
    ddr_datarate = 1066e6
    ddr_power_write_per_16bit = 180e-3 * 1.5
    ddr_power_read_per_16bit  = 220e-3 * 1.5

    bits_to_write = (1.0 * output_feature_size) * entropy_out
    bits_to_read = (1.0 * input_feature_size) * entropy_in
    design_energy = (1.0 * design_power) / fpga_frequency * calculation_clocks
    transfer_read_energy = (1.0 * ddr_power_read_per_16bit ) * (1.0 * bits_to_read / 16) * 4 / ddr_datarate
    transfer_write_energy = (1.0 * ddr_power_write_per_16bit ) * (1.0 * bits_to_write / 16) * 4 / ddr_datarate
    #print("")
    #print("Total energy: {:.3E}[J]".format((design_energy + transfer_read_energy + transfer_write_energy)))
    #print("Design energy: {:.3E}[J]".format(design_energy))
    #print("Transfer energy: {:.3E}[J]".format(transfer_write_energy + transfer_read_energy))
    #print("Transfer read energy {:.3E}[J], Transfer write energy {:.3E}[J]".format(transfer_read_energy, transfer_write_energy))

    return transfer_read_energy + transfer_write_energy

def batch_calc_power(param_file):
    f = open(param_file)
    result = []
    for line in f:
        params = str.split(line, ',')
        result.append(calc_power(*list(map(float, params))))

    print(result)

def calc_work():
    conv1 = 112*112*64
    conv2 = 56*56*64
    conv3 = 56*56*64
    conv4 = 56*56*64
    conv5 = 56*56*64
    conv6 = 28*28*128
    conv7 = 28*28*128
    conv8 = 28*28*128
    conv9 = 28*28*128
    conv10 = 14*14*256
    conv11 = 14*14*256
    conv12 = 14*14*256
    conv13 = 14*14*256
    conv14 = 7*7*512
    conv15 = 7*7*512
    conv16 = 7*7*512
    conv17 = 7*7*512

    net = [conv1, conv2, conv3, conv4, conv5, conv6, conv7, conv8, conv9, conv10, conv11, conv12, conv13, conv14, conv15, conv16, conv17]
    with_pca = [2.93009973, 3.26942563, 4.71617413, 4.68005085, 4.99061775, 4.67011929, 5.06910992, 5.4064126, 5.14067745, 4.36108351, 4.96772718, 4.33248615, 4.20540428, 3.50458884, 4.25482035, 3.41283941, 4.10771704]

    no_pca = [5.29655313, 5.76509619, 5.82527733, 5.99830198, 6.03460979, 6.62967873, 6.00120449, 6.42488289, 5.89619446, 6.3854661, 6.25196838, 6.38777876, 5.6490097, 6.56081724, 6.28340054, 6.43172026, 5.79630089]

    sum = 0
    for conv in net:
        sum += conv

    # for conv in net:
    #     print("{:3.2f}%".format(100.0 * conv / sum))

    avrg_entropy_no_pce = 0
    avrg_entropy_with_pce = 0

    for i in range(17):
        avrg_entropy_with_pce += (1.0 * with_pca[i] * net[i] / sum)
        avrg_entropy_no_pce += (1.0 * no_pca[i] * net[i] / sum)

    print("\n\n")
    print("Avarege entropy with PCA: {}\nAvarege entropy without PCA: {}".format(avrg_entropy_with_pce, avrg_entropy_no_pce))

# calc_power(*list(map(float, argv[1:])))

# calc_work()


batch_calc_power(argv[1])
