# -*- coding: mbcs -*-
#
# Abaqus/Viewer Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Sun Sep 24 20:34:52 2023
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=364.331237792969, 
    height=207.680557250977)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from viewerModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
o2 = session.openOdb(name='unit_shear.odb')
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/ex1/unit_shear.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       2
#: Number of Node Sets:          8
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o2)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=TIME_HISTORY)
session.viewports['Viewport: 1'].animationController.play(duration=UNLIMITED)
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=NONE)
#: Warning: The output database '/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/ex1/unit_shear.odb' disk file has changed.
#: 
#: The current plot operation has been canceled, re-open the file to view the results
session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/ex1/unit_shear.odb'].close(
    )
#* KeyError: 
#* /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/ex1/unit_shear.odb
o1 = session.openOdb(
    name='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/ex1/unit_shear.odb')
session.viewports['Viewport: 1'].setValues(displayedObject=o1)
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/ex1/unit_shear.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       2
#: Number of Node Sets:          8
#: Number of Steps:              1
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=TIME_HISTORY)
session.viewports['Viewport: 1'].animationController.play(duration=UNLIMITED)
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=NONE)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=TIME_HISTORY)
session.viewports['Viewport: 1'].animationController.play(duration=UNLIMITED)
session.viewports['Viewport: 1'].animationController.setValues(
    animationType=NONE)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    UNDEFORMED, ))
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    maxValue=12860.9, minValue=12860.5)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    animationAutoLimits=CURRENT_FRAME)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    animationAutoLimits=FIRST_AND_LAST)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    animationAutoLimits=ALL_FRAMES)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    maxAutoCompute=OFF, maxValue=300000, minAutoCompute=OFF, minValue=0)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    maxValue=30000)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    maxAutoCompute=ON)
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(COMPONENT, 
    'S11'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(COMPONENT, 
    'S22'), )
#: Warning: The user-specified Contour Min value must be less than the auto-computed Contour Max value.
#: The user-specified Contour Min value has been reset to the auto-computed Contour Min value.
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(COMPONENT, 
    'S33'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(COMPONENT, 
    'S22'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(COMPONENT, 
    'S12'), )
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    maxValue=7355.66, minValue=7354.06)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    showMaxLocation=ON)
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    maxAutoCompute=OFF, maxValue=7400)
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(COMPONENT, 
    'S13'), )
session.viewports['Viewport: 1'].odbDisplay.contourOptions.setValues(
    minValue=-8.78934E-18)
