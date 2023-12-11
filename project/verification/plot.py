import numpy as np
from matplotlib import pyplot as plt
import os

factor = 0.5

from run_sims import *

# fmt: off
plt.rcParams['figure.figsize'] = (6.0, 4.0)  # Adjust the values as needed


script_directory = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_directory)


# m_h = [1, 2, 10, 20, 100]
# m_h = [1,2]
# m_h = 1
# models = ["SolidSingle-UniTens", "SolidSingle-BiTens", "SolidSingle-SimpleShear"]

# i2component = {0: "22", 
#                1: "33", 
#                2: "11", 
#                3: "12"}

i2component_abq = {0: "11", 
               1: "22", 
               2: "33", 
               3: "23"}
i2component_natural = {0: "22", 
                       1: "33", 
                       2: "11", 
                       3: "12"}

i2component = i2component_natural
i2component = i2component_abq

class ModelData:
    def __init__(self) -> None:
        for i in range(len(i2component)):  # 4 stress components
            self.exp_S_E.append({})
            for m in m_h:
                self.exp_S_E[-1][m] = [[], []]
                self.exp_S_E[-1]["COMPARE"] = [[],[]]
    isvumat = None
    exp_S_E = []



data = []
for model in models:
    isshell = model.split("-")[0] == "ShellSingle" or model.split("-")[0]=="ShellPatch"
    
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
                    print("data",data)
                    print("2: ",md.exp_S_E[0][m][0])
                    print(m)
                    print(" ")
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
            print(header)
            print(header[2].strip().split(" "))
            
            if isshell:
                ind = 3
            else: 
                ind = 2
            if header[ind].strip().split(" ")[0] == "VUMAT":
                md.isvumat =True
            elif header[ind].strip().split(" ")[0] == "COMPARE":
                md.isvumat = False
            else:
                assert False

            if md.isvumat is False:
                m = "COMPARE"
            else:
                m = int(header[4].strip().split("_")[-1])
                assert m in m_h
            data = []
        else:
            # read xy
            xy = line.strip().split(",")
            data.append(float(xy[1]))
        

    # plot this model
    
    def set_label(component):
        if component == "11":
            labx = r"$LE_{11}$"
            laby = r"$S_{11}$"  
        elif component == "22":
            labx = r"$LE_{22}$"
            laby = r"$S_{22}$"
        elif component == "33":
            labx = r"$LE_{33}$"
            laby = r"$S_{33}$"
        elif component == "12":
            labx = r"$LE_{12}$"
            laby = r"$S_{12}$"
        elif component == "23":
            labx = r"$LE_{23}$"
            laby = r"$S_{23}$"
        else:
            assert False   
        plt.xlabel(labx)
        plt.ylabel(laby)

    for k, component in i2component.items():
        plt.figure(figsize=(factor*8,factor*6))
        set_label(component)
        legends = []
        for m in m_h:
            x = np.array(md.exp_S_E[k][m][0])
            y = np.array(md.exp_S_E[k][m][1])   
            assert len(x)>0 
            assert len(y)>0
            legends.append("Hershey m=" + str(m))
            plt.plot(x, y)
        legends.append("Mises builtin")
        x = np.array(md.exp_S_E[k]["COMPARE"][0])
        y = np.array(md.exp_S_E[k]["COMPARE"][1])
        plt.plot(x, y,'--')
        plt.legend(legends)
        plt.tight_layout()
        plt.savefig("output/"+model + "_" + component + ".png")
