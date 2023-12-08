# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Mon Dec  4 13:31:37 2023
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=369.887481689453, 
    height=179.633346557617)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
Mdb()
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=30.0)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)
session.viewports['Viewport: 1'].view.setValues(nearPlane=24.0686, 
    farPlane=32.4999, width=44.0026, height=28.3642, cameraPosition=(-9.88545, 
    -2.95964, 28.2843), cameraTarget=(-9.88545, -2.95964, 0))
session.viewports['Viewport: 1'].view.setValues(cameraPosition=(0.360909, 
    5.74947, 28.2843), cameraTarget=(0.360909, 5.74947, 0))
s.rectangle(point1=(0.0, 0.0), point2=(10.0, 10.0))
p = mdb.models['Model-1'].Part(name='Solid', dimensionality=THREE_D, 
    type=DEFORMABLE_BODY)
p = mdb.models['Model-1'].parts['Solid']
p.BaseSolidExtrude(sketch=s, depth=10.0)
s.unsetPrimaryObject()
p = mdb.models['Model-1'].parts['Solid']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
del mdb.models['Model-1'].sketches['__profile__']
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
