import numpy as np
from matplotlib import pyplot as plt
import os

# fmt: off

script_directory = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_directory)


m_h = [1, 2, 10, 20, 100]
m_h = [1,2]
models = ["SolidSingle-UniTens", "SolidSingle-BiTens", "SolidSingle-SimpleShear"]

i2component = {0: "22", 
               1: "33", 
               2: "11", 
               3: "12"}


class ModelData:
    def __init__(self) -> None:
        for i in range(len(i2component)):  # 4 stress components
            self.exp_S_E.append({})
            for m in m_h:
                self.exp_S_E[-1][m] = [[], []]
                self.exp_S_E[-1]["COMPARE"] = [[],[]]
                # self.exp_S_E_11[m] = ([], [])
                # self.exp_S_E_22[m] = ([], [])
                # self.exp_S_E_33[m] = ([], [])
                # self.exp_S_E_23[m] = ([], [])

    isvumat = None
    exp_S_E = []
    # exp_S_E_11 = {}
    # exp_S_E_22 = {}
    # exp_S_E_33 = {}
    # exp_S_E_23 = {}


data = []
for model in models:
    with open("output/" + model + ".txt", "r") as file:
        lines = file.readlines()
    md = ModelData()
    for i in range(len(lines)+1):
        if i<len(lines):
            line = lines[i]
        if line[0] == "_" or i==len(lines):
            if i > 0:
                # add data to md
                assert len(data)>0
                if variable == "LE11":
                    md.exp_S_E[0][m][0] = data
                elif variable == "LE22":
                    md.exp_S_E[1][m][0] = data
                elif variable == "LE33":
                    md.exp_S_E[2][m][0] = data
                elif variable == "LE23":
                    md.exp_S_E[3][m][0] = data
                elif variable == "S11":
                    md.exp_S_E[0][m][1] = data
                elif variable == "S22":
                    md.exp_S_E[1][m][1] = data
                elif variable == "S33":
                    md.exp_S_E[2][m][1] = data
                elif variable == "S23":
                    md.exp_S_E[3][m][1] = data
                else:
                    print("error: invalid case")
                    exit(1)
            if i==len(lines):
                break
            # parse header
            header = line.strip().split(":")
            variable = header[1].split(" ")[0]
            md.isvumat = header[2].strip().split(" ")[0] == "VUMAT"

            if md.isvumat is False:
                m = "COMPARE"
            else:
                m = int(header[4].strip()[-1])

            data = []
        else:
            # read xy
            xy = line.strip().split(",")
            data.append(float(xy[1]))
        

    # plot this model
    for k, component in i2component.items():
        plt.figure()
        plt.xlabel("LE" + component)
        plt.ylabel("S" + component)
        legends = []
        for m in m_h:
            x = np.array(md.exp_S_E[k][m][0])
            y = np.array(md.exp_S_E[k][m][1])   
            assert len(x)>0 and len(y)>0
            legends.append("Hershey m=" + str(m))
            plt.plot(x, y)
        legends.append("Mises builtin")
        x = np.array(md.exp_S_E[k]["COMPARE"][0])
        y = np.array(md.exp_S_E[k]["COMPARE"][1])
        plt.plot(x, y,'--')
        plt.legend(legends)
        plt.savefig("output/"+model + "_" + component + ".png")
