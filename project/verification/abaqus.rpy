# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Mon Dec 11 15:18:08 2023
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=209.549987792969, 
    height=97.5831985473633)
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
p = mdb.models['ShellSingle-UniTens'].parts['compare']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
execfile(
    '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py', 
    __main__.__dict__)
#: ('running job', 'SolidPatch-BiTens-m_1')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_1.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       9
#: Number of Node Sets:          9
#: Number of Steps:              1
#: ('running job', 'SolidPatch-BiTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       9
#: Number of Node Sets:          9
#: Number of Steps:              1
#* VisError: XY data extraction from field output was stopped by user request.
#* File 
#* "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py", 
#* line 104, in <module>
#*     )), ('COMPARE', 1, ('[#2000 ]', )), ), )
o7 = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_1.odb'].close(
    )
session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb'].close(
    )
execfile(
    '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py', 
    __main__.__dict__)
#: ('running job', 'SolidPatch-BiTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       9
#: Number of Node Sets:          9
#: Number of Steps:              1
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    DEFORMED, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=39.7459, 
    farPlane=71.8738, width=54.6793, height=29.1917, viewOffsetX=0.322517, 
    viewOffsetY=0.339042)
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=TIME_HISTORY)
session.viewports['Viewport: 1'].animationController.play(duration=UNLIMITED)
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=NONE)
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=TIME_HISTORY)
session.viewports['Viewport: 1'].animationController.play(duration=UNLIMITED)
session.viewports['Viewport: 1'].animationController.stop()
session.viewports['Viewport: 1'].animationController.showLastFrame()
session.viewports['Viewport: 1'].animationController.showLastFrame()
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=39.1095, 
    farPlane=70.2436, width=54.9018, height=29.3105, viewOffsetX=0.434262, 
    viewOffsetY=0.264811)
odb = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb']
xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
    variable=(('S', INTEGRATION_POINT, ((INVARIANT, 'Mises'), )), ), 
    elementPick=(('VUMAT', 1, ('[#1 ]', )), ), )
xyp = session.XYPlot('XYPlot-1')
chartName = xyp.charts.keys()[0]
chart = xyp.charts[chartName]
curveList = session.curveSet(xyData=xyList)
chart.setValues(curvesToPlot=curveList)
session.charts[chartName].autoColor(lines=True, symbols=True)
session.viewports['Viewport: 1'].setValues(displayedObject=xyp)
a = mdb.models['SolidPatch-BiTens'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='load')
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    adaptiveMeshConstraints=ON, optimizationTasks=OFF, 
    geometricRestrictions=OFF, stopConditions=OFF)
mdb.models['SolidPatch-BiTens'].steps['load'].setValues(timePeriod=0.1, 
    improvedDtMethod=ON)
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/Model.cae".
execfile(
    '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py', 
    __main__.__dict__)
#: ('running job', 'SolidPatch-BiTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       9
#: Number of Node Sets:          9
#: Number of Steps:              1
o7 = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=TIME_HISTORY)
session.viewports['Viewport: 1'].animationController.play(duration=UNLIMITED)
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=NONE)
session.viewports['Viewport: 1'].view.setValues(nearPlane=127.22, 
    farPlane=141.547, width=98.8145, height=52.7542, cameraPosition=(9.45994, 
    8.16527, 134.681), cameraUpVector=(-0.514908, 0.775952, -0.364373), 
    cameraTarget=(12.1368, 4.55133, -0.866796))
a = mdb.models['SolidPatch-BiTens'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['SolidPatch-BiTens'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.models['SolidPatch-BiTens'].steps['load'].setValues(timePeriod=0.01, 
    improvedDtMethod=ON)
a = mdb.models['SolidSingle-BiTens'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.models['SolidSingle-BiTens'].steps['load'].setValues(timePeriod=0.01, 
    improvedDtMethod=ON)
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/Model.cae".
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/Model.cae".
execfile(
    '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/run_sims.py', 
    __main__.__dict__)
#: ('running job', 'SolidSingle-UniTens-m_2')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-UniTens-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          4
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
o7 = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-BiTens-m_2.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
import allAbaqusMacros
allAbaqusMacros.overlay_plot()
session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
session.viewports['Viewport: 1'].view.setValues(session.views['Front'])
session.viewports['Viewport: 1'].view.setValues(nearPlane=33.2117, 
    farPlane=49.7577, width=48.2416, height=25.7548, cameraPosition=(4.44787, 
    5.85682, 46.4847), cameraTarget=(4.44787, 5.85682, 5))
session.viewports['Viewport: 1'].view.setValues(nearPlane=32.2888, 
    farPlane=50.762, cameraPosition=(6.87529, 9.39281, 46.2624), 
    cameraUpVector=(-0.0279657, 0.996097, -0.0837155))
session.viewports['Viewport: 1'].view.setValues(session.views['Back'])
allAbaqusMacros.overlay_plot()
session.viewports['Viewport: 1'].view.setValues(session.views['Front'])
session.viewports['Viewport: 1'].view.setValues(nearPlane=33.7558, 
    farPlane=49.2136, width=40.2213, height=21.473, cameraPosition=(4.5113, 
    5.36768, 46.4847), cameraTarget=(4.5113, 5.36768, 5))
session.viewports['Viewport: 1'].view.setValues(cameraPosition=(7.95332, 
    2.91307, 46.4847), cameraTarget=(7.95332, 2.91307, 5))
session.viewports['Viewport: 1'].view.setValues(nearPlane=33.7558, 
    farPlane=49.2136, width=40.2213, height=21.473, cameraPosition=(7.95332, 
    2.91307, 46.4847), cameraTarget=(7.95332, 2.91307, 5))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 1'].view.setValues(cameraUpVector=(-0.237712, 
    0.971336, 0))
p1 = mdb.models['SolidSingle-BiTens'].parts['compare']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
session.graphicsOptions.setValues(backgroundStyle=SOLID, 
    backgroundColor='#FFFFFF')
o7 = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidSingle-BiTens-m_2.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_UNDEF, CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
session.viewports['Viewport: 1'].view.setProjection(projection=PERSPECTIVE)
session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
session.viewports['Viewport: 1'].view.setValues(session.views['Front'])
session.viewports['Viewport: 1'].view.setValues(nearPlane=34.255, 
    farPlane=48.7144, width=32.8637, height=17.545, cameraPosition=(5.01825, 
    5.30168, 46.4847), cameraTarget=(5.01825, 5.30168, 5))
session.viewports['Viewport: 1'].view.setValues(cameraPosition=(5.41324, 
    3.62772, 46.4847), cameraTarget=(5.41324, 3.62772, 5))
session.viewports['Viewport: 1'].view.setValues(nearPlane=31.8704, 
    farPlane=51.099, width=65.3176, height=34.8712, cameraPosition=(7.68379, 
    5.13491, 46.4847), cameraTarget=(7.68379, 5.13491, 5))
o7 = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/./SolidPatch-BiTens-m_2.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
leaf = dgo.LeafFromPartInstance(partInstanceName=('COMPARE', ))
session.viewports['Viewport: 1'].odbDisplay.displayGroup.remove(leaf=leaf)
allAbaqusMacros.overlay_plot_biax()
session.viewports['Viewport: 1'].view.setValues(nearPlane=28.0257, 
    farPlane=54.9437, width=124.68, height=66.5629, cameraPosition=(9.20947, 
    11.1503, 46.4847), cameraTarget=(9.20947, 11.1503, 5))
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=40 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=0 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=1 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=2 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=3 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=4 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=5 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=6 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=7 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=8 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=9 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=10 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=11 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=12 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=13 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=14 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=15 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=16 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=17 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=18 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=19 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=20 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=21 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=22 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=23 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=24 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=25 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=26 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=27 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=28 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=29 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=30 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=31 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=32 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=33 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=34 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=35 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=36 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=37 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=38 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=39 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=40 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=40 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=40 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=39 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=38 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=37 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=36 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=35 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=34 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=33 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=32 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=31 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=30 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=29 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=28 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=27 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=26 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=25 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=24 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=23 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=22 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=21 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=20 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=19 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=18 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=17 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=16 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=15 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=14 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=13 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=12 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=11 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=10 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=9 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=8 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=7 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=6 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=5 )
session.viewports['Viewport: 1'].odbDisplay.setFrame(step=0, frame=4 )
allAbaqusMacros.overlay_plot_biax()
session.viewports['Viewport: 1'].view.setValues(nearPlane=32.4789, 
    farPlane=50.4905, width=59.042, height=31.5208, cameraPosition=(5.55434, 
    6.05969, 46.4847), cameraTarget=(5.55434, 6.05969, 5))
o1 = session.openOdb(
    name='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/SolidSingle-SimpleShear-m_2.odb')
session.viewports['Viewport: 1'].setValues(displayedObject=o1)
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/SolidSingle-SimpleShear-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       12
#: Number of Node Sets:          12
#: Number of Steps:              1
o1 = session.openOdb(
    name='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/SolidPatch-SimpleShear-m_2.odb')
session.viewports['Viewport: 1'].setValues(displayedObject=o1)
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/SolidPatch-SimpleShear-m_2.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       13
#: Number of Node Sets:          13
#: Number of Steps:              1
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    DEFORMED, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=31.6464, 
    farPlane=66.2333, width=55.4442, height=29.6001, cameraPosition=(37.4883, 
    35.9478, 34.7679), cameraTarget=(8.25366, 6.71315, 5.53319))
session.viewports['Viewport: 1'].view.setValues(nearPlane=35.8509, 
    farPlane=65.808, cameraPosition=(19.4661, 25.0271, -38.0959), 
    cameraUpVector=(-0.775226, 0.502291, 0.383052), cameraTarget=(8.87824, 
    7.09163, 8.05838))
session.viewports['Viewport: 1'].view.setValues(nearPlane=34.8472, 
    farPlane=69.6596, cameraPosition=(-19.3412, 25.6484, -29.7478), 
    cameraUpVector=(0.128154, 0.705548, 0.696978), cameraTarget=(8.73052, 
    7.094, 8.09016))
session.viewports['Viewport: 1'].view.setValues(nearPlane=37.4367, 
    farPlane=65.8202, cameraPosition=(15.1129, 31.9712, -35.9959), 
    cameraUpVector=(-0.119879, 0.660334, 0.741342), cameraTarget=(9.79699, 
    7.28971, 7.89676))
session.viewports['Viewport: 1'].view.setValues(nearPlane=34.9208, 
    farPlane=69.9615, cameraPosition=(-36.0528, 17.9977, -12.3992), 
    cameraUpVector=(0.292351, 0.758422, 0.582518), cameraTarget=(8.81336, 
    7.02108, 8.35039))
session.viewports['Viewport: 1'].view.setValues(nearPlane=34.7498, 
    farPlane=69.9904, cameraPosition=(42.2342, 32.5774, -23.5321), 
    cameraUpVector=(-0.578475, 0.651996, 0.490171), cameraTarget=(11.5083, 
    7.52297, 7.96716))
session.viewports['Viewport: 1'].view.setValues(nearPlane=34.8753, 
    farPlane=69.8222, cameraPosition=(39.7521, -17.5634, 45.0648), 
    cameraUpVector=(-0.0526593, 0.975357, 0.214254), cameraTarget=(11.4261, 
    5.8627, 10.2386))
session.viewports['Viewport: 1'].view.setValues(nearPlane=35.3776, 
    farPlane=68.6322, cameraPosition=(60.3123, 10.7056, -6.41623), 
    cameraUpVector=(-0.254623, 0.81488, 0.520708), cameraTarget=(12.0988, 
    6.78758, 8.55429))
a = mdb.models['SolidSingle-UniTens'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Initial')
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, adaptiveMeshConstraints=OFF)
session.viewports['Viewport: 1'].view.setValues(nearPlane=37.74, 
    farPlane=72.4949, width=31.4853, height=15.12, cameraPosition=(61.6194, 
    25.5929, 6.3298), cameraUpVector=(-0.670778, 0.732847, -0.113987), 
    cameraTarget=(11.3162, 4.20889, 4.97489))
a = mdb.models['SolidSingle-SimpleShear'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='load')
session.viewports['Viewport: 1'].view.setValues(nearPlane=38.4243, 
    farPlane=69.4142, width=32.0562, height=15.3942, cameraPosition=(-4.93675, 
    38.5303, 44.312), cameraUpVector=(0.0425306, 0.4882, -0.871695), 
    cameraTarget=(11.3162, 4.20889, 4.97489))
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Initial')
a = mdb.models['SolidSingle-SimpleShear'].rootAssembly
f1 = a.instances['vumat'].faces
faces1 = f1.getSequenceFromMask(mask=('[#1 ]', ), )
f2 = a.instances['compare'].faces
faces2 = f2.getSequenceFromMask(mask=('[#1 ]', ), )
region = a.Set(faces=faces1+faces2, name='Set-13')
mdb.models['SolidSingle-SimpleShear'].XsymmBC(name='symside', 
    createStepName='Initial', region=region, localCsys=None)
del mdb.models['SolidSingle-SimpleShear'].boundaryConditions['symside']
session.viewports['Viewport: 1'].view.setValues(nearPlane=37.841, 
    farPlane=68.6058, width=31.5697, height=15.1605, cameraPosition=(-8.0458, 
    49.4064, -17.7395), cameraUpVector=(0.425764, 0.234776, 0.873845), 
    cameraTarget=(11.3599, 4.05614, 5.84639))
a = mdb.models['SolidSingle-SimpleShear'].rootAssembly
f1 = a.instances['vumat'].faces
faces1 = f1.getSequenceFromMask(mask=('[#30 ]', ), )
f2 = a.instances['compare'].faces
faces2 = f2.getSequenceFromMask(mask=('[#30 ]', ), )
region = a.Set(faces=faces1+faces2, name='Set-14')
mdb.models['SolidSingle-SimpleShear'].ZsymmBC(name='constrained-sides', 
    createStepName='Initial', region=region, localCsys=None)
a = mdb.models['SolidPatch-SimpleShear'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].view.setValues(nearPlane=37.5144, 
    farPlane=72.1425, width=31.2972, height=15.0296, cameraPosition=(42.8946, 
    27.498, -33.1033), cameraUpVector=(-0.361516, 0.705077, 0.61006), 
    cameraTarget=(11.3162, 4.20889, 4.9749))
a = mdb.models['SolidPatch-SimpleShear'].rootAssembly
f1 = a.instances['compare'].faces
faces1 = f1.getSequenceFromMask(mask=('[#30 ]', ), )
f2 = a.instances['vumat'].faces
faces2 = f2.getSequenceFromMask(mask=('[#30 ]', ), )
region = a.Set(faces=faces1+faces2, name='Set-14')
mdb.models['SolidPatch-SimpleShear'].ZsymmBC(name='constrained-sides', 
    createStepName='Initial', region=region, localCsys=None)
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/Model.cae".
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/Model.cae".
