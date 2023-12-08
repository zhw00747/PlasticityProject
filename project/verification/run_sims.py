from abaqus import *
from abaqusConstants import *
from caeModules import *

# fmt: off

def add_vumat_material(input_file_no_ext, m):

    input_file = input_file_no_ext+".inp"
    inserted_text = '''
*density
7.0e-9
*user material, CONSTANTS=17
**      E,     nu,  sigma0,  Q1,   C1,     Q2,      C2,    Q3,
210000.0,    0.3,  290.7,   129.2, 168.6, 209.8,   10.68,  455.3,      
**       C3,   n (hershey),  cp,      betaTQ,  T0,      Tm,       m,    pdot0,
         0.805,  {}.,            452e6,   0.9,     293.0,   1800.0,   1000.0,  5e-5,
**       c
         0.0
*depvar
2
**1, p, "Euivalent plastic strain" 
**2, T, "Temperature"
    '''.format(m)

    with open(input_file, 'r') as file:
        lines = file.readlines()
    vumat_index = lines.index('*Material, name=VUMAT\n')
    lines.insert(vumat_index + 1, inserted_text)

    output_file_no_ext = input_file_no_ext + "-m_"+str(m)
    with open(output_file_no_ext+".inp", 'w') as file:
        file.writelines(lines)
    return output_file_no_ext

herhsey_m = [1,2,10,20,100]
herhsey_m = [1,2]

models = ['SolidSingle-UniTens','SolidSingle-BiTens', 'SolidSingle-SimpleShear']

for model in models:
    mdb.Job(name=model, model=model, 
        description='', type=ANALYSIS, atTime=None, waitMinutes=0, waitHours=0, 
        queue=None, memory=90, memoryUnits=PERCENTAGE, explicitPrecision=SINGLE, 
        nodalOutputPrecision=SINGLE, echoPrint=OFF, modelPrint=OFF, 
        contactPrint=OFF, historyPrint=OFF, userSubroutine='', scratch='', 
        resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, numDomains=1, 
        activateLoadBalancing=False, numThreadsPerMpiProcess=1, 
        multiprocessingMode=DEFAULT, numCpus=1)
    mdb.jobs[model].writeInput(consistencyChecking=OFF)

    data = ""
    
    for m in herhsey_m:
        jobname = add_vumat_material(model,m)

        print("running job",jobname)
        import subprocess
        subprocess.call(['bash','run.sh',jobname])

        odb = session.openOdb(
        name='./'+jobname+'.odb')
        session.viewports['Viewport: 1'].setValues(displayedObject=odb)
        xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
            variable=(('S', INTEGRATION_POINT, ((COMPONENT, 'S11'),
                                                (COMPONENT, 'S22'),
                                                (COMPONENT, 'S33'),
                                                (COMPONENT, 'S23'),)),
                      ('LE', INTEGRATION_POINT, ((COMPONENT, 'LE11'),
                                                (COMPONENT, 'LE22'),
                                                (COMPONENT, 'LE33'),
                                                (COMPONENT, 'LE23')),)), 
            elementPick=(('VUMAT', 1, ('[#1 ]', )), ('COMPARE', 1, (
            '[#1 ]', )), ), )
        
        # xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
        #     variable=(('LE', INTEGRATION_POINT, ((COMPONENT, 'LE11'), )), ('S', 
        #     INTEGRATION_POINT, ((COMPONENT, 'S11'),
        #                                         (COMPONENT, 'S22'),
        #                                         (COMPONENT, 'S33'),
        #                                         (COMPONENT, 'S23'), )), ), elementPick=(('VUMAT', 1, (
        #     '[#1 ]', )), ), )
        
        for xyData in xyList:
            name = xyData.name
            data += name+"-m_"+str(m)+"\n"
            for pair in xyData.data:
                data += str(pair[0]) + ","+str(pair[1])+"\n"



     
            # x_values = xyData.data[0]
            # for x in x_values:
            #     print(x)

        #xyp = session.xyPlots['XYPlot-1']
        #chartName = xyp.charts.keys()[0]
        #chart = xyp.charts[chartName]
        #curveList = session.curveSet(xyData=xyList)
        #chart.setValues(curvesToPlot=curveList)
        #session.charts[chartName].autoColor(lines=True, symbols=True)
        #session.viewports['Viewport: 1'].setValues(displayedObject=xyp)

        
        
        
        
        
        

    
    
    output_name = "./output/"+model +".txt"
    with open(output_name,"w") as xy_out:
        xy_out.writelines(data)
