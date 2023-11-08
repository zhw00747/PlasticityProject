# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Mon Nov  6 10:41:45 2023
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=364.129211425781, 
    height=208.227066040039)
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
s = mdb.models['Model-1'].ConstrainedSketch(name='__profile__', sheetSize=10.0)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)
session.viewports['Viewport: 1'].view.setValues(nearPlane=7.90993, 
    farPlane=10.9463, width=13.6203, height=8.8648, cameraPosition=(1.38244, 
    0.951931, 9.42809), cameraTarget=(1.38244, 0.951931, 0))
s.rectangle(point1=(0.0, 0.0), point2=(5.0, 5.0))
p = mdb.models['Model-1'].Part(name='Part-1', dimensionality=THREE_D, 
    type=DEFORMABLE_BODY)
p = mdb.models['Model-1'].parts['Part-1']
p.BaseShell(sketch=s)
s.unsetPrimaryObject()
p = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
del mdb.models['Model-1'].sketches['__profile__']
session.viewports['Viewport: 1'].view.setValues(nearPlane=13.1759, 
    farPlane=15.1084, width=9.01377, height=5.86665, viewOffsetX=-0.128951, 
    viewOffsetY=0.0375132)
session.viewports['Viewport: 1'].view.setValues(nearPlane=11.1098, 
    farPlane=16.9629, width=7.60031, height=4.94669, cameraPosition=(13.187, 
    2.25506, 9.09676), cameraUpVector=(-0.0554886, 0.99414, 0.0927754), 
    cameraTarget=(2.45362, 2.51498, -0.108025), viewOffsetX=-0.10873, 
    viewOffsetY=0.0316307)
session.viewports['Viewport: 1'].view.setValues(nearPlane=11.2514, 
    farPlane=16.8214, width=7.69717, height=5.00973, viewOffsetX=-0.110116, 
    viewOffsetY=0.0320338)
session.viewports['Viewport: 1'].view.setValues(nearPlane=11.2522, 
    farPlane=16.8206, width=7.6977, height=5.01008, viewOffsetX=-0.110124, 
    viewOffsetY=0.032036)
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
mdb.models['Model-1'].Material(name='Material-1')
mdb.models['Model-1'].HomogeneousShellSection(name='Section-1', 
    preIntegrate=OFF, material='Material-1', thicknessType=UNIFORM, 
    thickness=0.1, thicknessField='', nodalThicknessField='', 
    idealization=NO_IDEALIZATION, poissonDefinition=DEFAULT, 
    thicknessModulus=None, temperature=GRADIENT, useDensity=OFF, 
    integrationRule=SIMPSON, numIntPts=5)
session.viewports['Viewport: 1'].view.setValues(nearPlane=11.2974, 
    farPlane=16.7754, width=7.42258, height=4.83101, viewOffsetX=-0.126932, 
    viewOffsetY=0.0319071)
p = mdb.models['Model-1'].parts['Part-1']
f = p.faces
faces = f.getSequenceFromMask(mask=('[#1 ]', ), )
region = p.Set(faces=faces, name='Set-1')
p = mdb.models['Model-1'].parts['Part-1']
p.SectionAssignment(region=region, sectionName='Section-1', offset=0.0, 
    offsetType=MIDDLE_SURFACE, offsetField='', 
    thicknessAssignment=FROM_SECTION)
session.viewports['Viewport: 1'].view.setValues(nearPlane=11.1509, 
    farPlane=16.9219, width=8.78722, height=5.71919, viewOffsetX=-0.547826, 
    viewOffsetY=-0.0072933)
session.viewports['Viewport: 1'].view.setValues(nearPlane=10.3518, 
    farPlane=17.2678, width=8.15751, height=5.30935, cameraPosition=(15.5419, 
    1.74307, 4.47841), cameraUpVector=(-0.00119863, 0.984469, 0.175553), 
    cameraTarget=(2.21862, 2.55992, -0.193274), viewOffsetX=-0.508568, 
    viewOffsetY=-0.00677065)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, optimizationTasks=OFF, 
    geometricRestrictions=OFF, stopConditions=OFF)
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=OFF, 
    engineeringFeatures=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p1 = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
session.viewports['Viewport: 1'].view.setValues(nearPlane=10.5113, 
    farPlane=17.1083, width=10.6727, height=6.73278, viewOffsetX=-0.214041, 
    viewOffsetY=0.187082)
session.viewports['Viewport: 1'].view.setValues(nearPlane=10.1748, 
    farPlane=17.6519, width=12.5144, height=6.51722, cameraPosition=(12.2832, 
    1.92866, 9.87728), cameraUpVector=(-0.092015, 0.984294, 0.150662), 
    cameraTarget=(2.42818, 2.55696, -0.246236), viewOffsetX=-0.207188, 
    viewOffsetY=0.181093)
session.viewports['Viewport: 1'].view.setValues(nearPlane=10.2165, 
    farPlane=17.6102, width=11.3585, height=5.91522, viewOffsetX=-0.484128, 
    viewOffsetY=0.0654527)
p = mdb.models['Model-1'].parts['Part-1']
e = p.edges
edges = e.getSequenceFromMask(mask=('[#1 ]', ), )
p.Set(edges=edges, name='encas')
#: The set 'encas' has been created (1 edge).
p = mdb.models['Model-1'].parts['Part-1']
e = p.edges
edges = e.getSequenceFromMask(mask=('[#4 ]', ), )
p.Set(edges=edges, name='load')
#: The set 'load' has been created (1 edge).
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
p = mdb.models['Model-1'].parts['Part-1']
p.seedPart(size=0.5, deviationFactor=0.1, minSizeFactor=0.1)
p = mdb.models['Model-1'].parts['Part-1']
p.generateMesh()
p = mdb.models['Model-1'].parts['Part-1']
p.deleteMesh()
p = mdb.models['Model-1'].parts['Part-1']
p.seedPart(size=5.0, deviationFactor=0.1, minSizeFactor=0.1)
p = mdb.models['Model-1'].parts['Part-1']
p.generateMesh()
elemType1 = mesh.ElemType(elemCode=S4R, elemLibrary=EXPLICIT, 
    secondOrderAccuracy=OFF, hourglassControl=DEFAULT)
elemType2 = mesh.ElemType(elemCode=S3R, elemLibrary=EXPLICIT)
p = mdb.models['Model-1'].parts['Part-1']
f = p.faces
faces = f.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(faces, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2))
p = mdb.models['Model-1'].parts['Part-1']
p.generateMesh()
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
mdb.Job(name='Job-1', model='Model-1', description='', type=ANALYSIS, 
    atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
    memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
    explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
    modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='', 
    scratch='', resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, 
    numDomains=1, activateLoadBalancing=False, numThreadsPerMpiProcess=1, 
    multiprocessingMode=DEFAULT, numCpus=1, numGPUs=0)
a = mdb.models['Model-1'].rootAssembly
a.DatumCsysByDefault(CARTESIAN)
p = mdb.models['Model-1'].parts['Part-1']
a.Instance(name='Part-1-1', part=p, dependent=ON)
mdb.jobs['Job-1'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Job-1.inp".
mdb.jobs.changeKey(fromName='Job-1', toName='unit_shell_exp')
mdb.jobs['unit_shell_exp'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "unit_shell_exp.inp".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON)
session.viewports['Viewport: 1'].view.setValues(nearPlane=12.4709, 
    farPlane=15.8133, width=10.6625, height=5.55276, viewOffsetX=0.110914, 
    viewOffsetY=0.09428)
session.viewports['Viewport: 1'].view.setValues(nearPlane=9.90084, 
    farPlane=18.5851, width=8.46508, height=4.40841, cameraPosition=(15.5708, 
    0.534312, 5.30635), cameraUpVector=(0.102857, 0.988044, 0.114848), 
    cameraTarget=(2.56706, 2.49276, 0.103783), viewOffsetX=0.088056, 
    viewOffsetY=0.0748502)
session.viewports['Viewport: 1'].view.setValues(nearPlane=10.2001, 
    farPlane=18.2859, width=8.72091, height=4.54164, viewOffsetX=0.0907172, 
    viewOffsetY=0.0771123)
a = mdb.models['Model-1'].rootAssembly
region = a.instances['Part-1-1'].sets['encas']
mdb.models['Model-1'].ZsymmBC(name='bc', createStepName='Initial', 
    region=region, localCsys=None)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p1 = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
p = mdb.models['Model-1'].parts['Part-1']
e = p.edges
edges = e.getSequenceFromMask(mask=('[#8 ]', ), )
p.Set(edges=edges, name='x0_face')
#: The set 'x0_face' has been created (1 edge).
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['Model-1'].rootAssembly
region = a.instances['Part-1-1'].sets['x0_face']
mdb.models['Model-1'].XsymmBC(name='bc_x0', createStepName='Initial', 
    region=region, localCsys=None)
del mdb.models['Model-1'].boundaryConditions['bc_x0']
a = mdb.models['Model-1'].rootAssembly
region = a.instances['Part-1-1'].sets['x0_face']
mdb.models['Model-1'].DisplacementBC(name='x0_face_bc', 
    createStepName='Initial', region=region, u1=SET, u2=UNSET, u3=UNSET, 
    ur1=UNSET, ur2=UNSET, ur3=UNSET, amplitude=UNSET, distributionType=UNIFORM, 
    fieldName='', localCsys=None)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF, adaptiveMeshConstraints=ON)
mdb.models['Model-1'].ExplicitDynamicsStep(name='load', previous='Initial', 
    timePeriod=0.1, improvedDtMethod=ON)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='load')
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, adaptiveMeshConstraints=OFF)
mdb.models['Model-1'].SmoothStepAmplitude(name='Amp-1', timeSpan=TOTAL, data=((
    0.0, 0.0), (0.001, 1.0), (10.0, 1.0)))
a = mdb.models['Model-1'].rootAssembly
region = a.instances['Part-1-1'].sets['load']
mdb.models['Model-1'].VelocityBC(name='bc_vel', createStepName='load', 
    region=region, v1=UNSET, v2=100.0, v3=UNSET, vr1=UNSET, vr2=UNSET, 
    vr3=UNSET, amplitude='Amp-1', localCsys=None, distributionType=UNIFORM, 
    fieldName='')
mdb.saveAs(
    pathName='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey-Shell/shell')
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey-Shell/shell.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
mdb.jobs['unit_shell_exp'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "unit_shell_exp.inp".
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey-Shell/shell.cae".
