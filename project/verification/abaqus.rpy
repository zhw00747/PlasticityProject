# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Fri Dec  8 12:39:22 2023
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=254.210464477539, 
    height=117.946090698242)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
openMdb('Model.cae')
#: The model database "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/Model.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p = mdb.models['SolidSingle-BiTens'].parts['compare']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
execfile(
    '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py', 
    __main__.__dict__)
#: ('running job', 'SolidSingle-UniTens-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          4
#: Number of Steps:              1
#: ('running job', 'SolidSingle-UniTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          4
#: Number of Steps:              1
#: ('running job', 'SolidSingle-BiTens-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-BiTens-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       8
#: Number of Node Sets:          8
#: Number of Steps:              1
#: ('running job', 'SolidSingle-BiTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-BiTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       8
#: Number of Node Sets:          8
#: Number of Steps:              1
#: ('running job', 'SolidSingle-SimpleShear-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-SimpleShear-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       12
#: Number of Node Sets:          12
#: Number of Steps:              1
#: ('running job', 'SolidSingle-SimpleShear-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-SimpleShear-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       12
#: Number of Node Sets:          12
#: Number of Steps:              1
o7 = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_1.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
odb = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_1.odb']
xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
    variable=(('LE', INTEGRATION_POINT, ((COMPONENT, 'LE11'), )), ), 
    elementPick=(('VUMAT', 1, ('[#1 ]', )), ), )
xyp = session.XYPlot('XYPlot-1')
chartName = xyp.charts.keys()[0]
chart = xyp.charts[chartName]
curveList = session.curveSet(xyData=xyList)
chart.setValues(curvesToPlot=curveList)
session.charts[chartName].autoColor(lines=True, symbols=True)
session.viewports['Viewport: 1'].setValues(displayedObject=xyp)
odb = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_1.odb']
xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
    variable=(('LE', INTEGRATION_POINT, ((COMPONENT, 'LE11'), )), ('S', 
    INTEGRATION_POINT, ((COMPONENT, 'S11'), )), ), elementPick=(('VUMAT', 1, (
    '[#1 ]', )), ), )
xyp = session.xyPlots['XYPlot-1']
chartName = xyp.charts.keys()[0]
chart = xyp.charts[chartName]
curveList = session.curveSet(xyData=xyList)
chart.setValues(curvesToPlot=curveList)
session.charts[chartName].autoColor(lines=True, symbols=True)
execfile(
    '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py', 
    __main__.__dict__)
#: ('running job', 'SolidSingle-UniTens-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          4
#: Number of Steps:              1
#* TypeError: variable[1]; too many arguments; expected 2, got 6
#* File 
#* "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py", 
#* line 74, in <module>
#*     '[#1 ]', )), ), )
execfile(
    '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py', 
    __main__.__dict__)
#: ('running job', 'SolidSingle-UniTens-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          4
#: Number of Steps:              1
#: ('running job', 'SolidSingle-UniTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          4
#: Number of Steps:              1
#: ('running job', 'SolidSingle-BiTens-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-BiTens-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       8
#: Number of Node Sets:          8
#: Number of Steps:              1
#: ('running job', 'SolidSingle-BiTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-BiTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       8
#: Number of Node Sets:          8
#: Number of Steps:              1
#: ('running job', 'SolidSingle-SimpleShear-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-SimpleShear-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       12
#: Number of Node Sets:          12
#: Number of Steps:              1
#: ('running job', 'SolidSingle-SimpleShear-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-SimpleShear-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       12
#: Number of Node Sets:          12
#: Number of Steps:              1
