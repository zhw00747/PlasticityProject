# -*- coding: mbcs -*-
#
# Abaqus/Viewer Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Thu Nov  2 00:45:32 2023
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=364.331237792969, 
    height=208.409271240234)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from viewerModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
o1 = session.openOdb(
    name='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/unit_exp.odb')
session.viewports['Viewport: 1'].setValues(displayedObject=o1)
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/unit_exp.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       2
#: Number of Node Sets:          8
#: Number of Steps:              1
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=18.815, 
    farPlane=36.5846, width=19.6302, height=13.072, viewOffsetX=1.71916, 
    viewOffsetY=0.842247)
session.viewports['Viewport: 1'].view.setValues(nearPlane=18.7793, 
    farPlane=36.6203, width=19.593, height=13.0472, cameraPosition=(22.0367, 
    18.7046, 18.7753), cameraUpVector=(-0.487839, 0.570877, -0.660389), 
    cameraTarget=(5.69782, 2.36573, 2.43646), viewOffsetX=1.71591, 
    viewOffsetY=0.84065)
session.viewports['Viewport: 1'].view.setValues(nearPlane=20.4545, 
    farPlane=35.3049, width=21.3408, height=14.2111, cameraPosition=(15.0954, 
    29.9906, 4.27115), cameraUpVector=(-0.930413, -0.0773698, -0.358253), 
    cameraTarget=(7.59273, 2.72029, 3.31437), viewOffsetX=1.86898, 
    viewOffsetY=0.91564)
session.viewports['Viewport: 1'].view.setValues(nearPlane=18.9575, 
    farPlane=37.4422, width=19.779, height=13.1711, cameraPosition=(25.5996, 
    16.8788, 17.0324), cameraUpVector=(-0.603222, 0.628692, -0.490785), 
    cameraTarget=(6.17075, 2.08058, 2.73524), viewOffsetX=1.7322, 
    viewOffsetY=0.848629)
session.viewports['Viewport: 1'].view.setValues(nearPlane=18.9134, 
    farPlane=35.3049, width=19.733, height=13.1405, cameraPosition=(18.8799, 
    11.8725, 24.6627), cameraUpVector=(-0.535489, 0.721106, -0.439611), 
    cameraTarget=(5.73977, 1.33291, 1.92218), viewOffsetX=1.72817, 
    viewOffsetY=0.846654)
odb = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/unit_exp.odb']
xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
    variable=(('S', INTEGRATION_POINT, ((INVARIANT, 'Mises'), )), ), 
    elementPick=(('REF', 1, ('[#1 ]', )), ), )
xyp = session.XYPlot('XYPlot-1')
chartName = xyp.charts.keys()[0]
chart = xyp.charts[chartName]
curveList = session.curveSet(xyData=xyList)
chart.setValues(curvesToPlot=curveList)
session.charts[chartName].autoColor(lines=True, symbols=True)
session.viewports['Viewport: 1'].setValues(displayedObject=xyp)
session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/unit_exp.odb'].close(
    )
c1 = session.curves['_S:Mises PI: REF E: 1 IP: 1']
session.charts['Chart-1'].removeCurve(curve=(c1, ))
o1 = session.openOdb(
    name='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/unit_shear.odb')
session.viewports['Viewport: 1'].setValues(displayedObject=o1)
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/unit_shear.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       2
#: Number of Node Sets:          8
#: Number of Steps:              1
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
odb = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/unit_shear.odb']
xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
    variable=(('S', INTEGRATION_POINT, ((INVARIANT, 'Mises'), )), ), 
    elementPick=(('VUMAT', 1, ('[#1 ]', )), ), )
xyp = session.xyPlots['XYPlot-1']
chartName = xyp.charts.keys()[0]
chart = xyp.charts[chartName]
curveList = session.curveSet(xyData=xyList)
chart.setValues(curvesToPlot=curveList)
session.charts[chartName].autoColor(lines=True, symbols=True)
session.viewports['Viewport: 1'].setValues(displayedObject=xyp)
