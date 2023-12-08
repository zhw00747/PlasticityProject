# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Mon Dec  4 14:16:46 2023
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
session.viewports['Viewport: 1'].view.setValues(nearPlane=24.7054, 
    farPlane=31.8631, width=37.3558, height=24.0797, cameraPosition=(-4.06844, 
    0.308309, 28.2843), cameraTarget=(-4.06844, 0.308309, 0))
session.viewports['Viewport: 1'].view.setValues(cameraPosition=(6.73508, 
    7.39803, 28.2843), cameraTarget=(6.73508, 7.39803, 0))
session.viewports['Viewport: 1'].view.setValues(nearPlane=24.704, 
    farPlane=31.8646, width=35.8915, height=23.1358, cameraPosition=(6.3957, 
    7.10445, 28.2843), cameraTarget=(6.3957, 7.10445, 0))
s.rectangle(point1=(0.0, 0.0), point2=(10.0, 10.0))
p = mdb.models['Model-1'].Part(name='solid-single', dimensionality=THREE_D, 
    type=DEFORMABLE_BODY)
p = mdb.models['Model-1'].parts['solid-single']
p.BaseSolidExtrude(sketch=s, depth=10.0)
s.unsetPrimaryObject()
p = mdb.models['Model-1'].parts['solid-single']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
del mdb.models['Model-1'].sketches['__profile__']
mdb.saveAs(
    pathName='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model')
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model.cae".
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
mdb.models['Model-1'].Material(name='elastic-plastic')
mdb.models['Model-1'].materials['elastic-plastic'].Density(table=((7e-09, ), ))
mdb.models['Model-1'].materials['elastic-plastic'].Elastic(table=((210000.0, 
    0.3), ))
mdb.models['Model-1'].materials['elastic-plastic'].Plastic(scaleStress=None, 
    table=((290.7, 0.0), (417.823605744229, 0.0101010101010101), (
    456.329975287288, 0.0202020202020202), (477.126340495284, 
    0.0303030303030303), (493.287652356567, 0.0404040404040404), (
    507.339404059617, 0.0505050505050505), (519.870967360417, 
    0.0606060606060606), (531.105853631708, 0.0707070707070707), (
    541.189059988528, 0.0808080808080808), (550.240618734234, 
    0.0909090909090909), (558.366440998646, 0.101010101010101), (
    565.661270801933, 0.111111111111111), (572.210102057556, 
    0.121212121212121), (578.089225741759, 0.131313131313131), (
    583.367129009875, 0.141414141414141), (588.105294904613, 
    0.151515151515152), (592.358918924397, 0.161616161616162), (
    596.177552065358, 0.171717171717172), (599.605678058458, 
    0.181818181818182), (602.683231568067, 0.191919191919192), (
    605.44606339619, 0.202020202020202), (607.926358112973, 0.212121212121212), 
    (610.153008978756, 0.222222222222222), (612.151954525245, 
    0.232323232323232), (613.946480716678, 0.242424242424242), (
    615.557492210912, 0.252525252525252), (617.003755880367, 
    0.262626262626263), (618.302119429646, 0.272727272727273), (
    619.467707656537, 0.282828282828283), (620.514098642654, 
    0.292929292929293), (621.453481926188, 0.303030303030303), (
    622.296800499352, 0.313131313131313), (623.053878284649, 
    0.323232323232323), (623.733534574964, 0.333333333333333), (
    624.343686770598, 0.343434343434343), (624.891442610045, 
    0.353535353535354), (625.383182968919, 0.363636363636364), (
    625.824636191561, 0.373737373737374), (626.220944821236, 
    0.383838383838384), (626.576725506254, 0.393939393939394), (
    626.896122779878, 0.404040404040404), (627.182857340505, 
    0.414141414141414), (627.440269394545, 0.424242424242424), (
    627.671357566895, 0.434343434343434), (627.878813832295, 
    0.444444444444444), (628.065054874474, 0.454545454545455), (
    628.232250238398, 0.464646464646465), (628.382347603569, 
    0.474747474747475), (628.517095472784, 0.484848484848485), (
    628.638063540658, 0.494949494949495), (628.746660979197, 
    0.505050505050505), (628.844152853412, 0.515151515151515), (
    628.931674858221, 0.525252525252525), (629.010246548295, 
    0.535353535353535), (629.080783214985, 0.545454545454546), (
    629.144106548657, 0.555555555555556), (629.200954210667, 
    0.565656565656566), (629.25198842647, 0.575757575757576), (
    629.297803699967, 0.585858585858586), (629.338933738953, 
    0.595959595959596), (629.375857672347, 0.606060606060606), (
    629.40900563162, 0.616161616161616), (629.438763761457, 0.626262626262626), 
    (629.465478717997, 0.636363636363636), (629.489461707077, 
    0.646464646464646), (629.510992109508, 0.656565656565657), (
    629.530320735614, 0.666666666666667), (629.547672746955, 
    0.676767676767677), (629.563250279259, 0.686868686868687), (
    629.57723479713, 0.696969696969697), (629.589789207948, 0.707070707070707), 
    (629.6010597596, 0.717171717171717), (629.611177744138, 0.727272727272727), 
    (629.620261027217, 0.737373737373737), (629.628415421126, 
    0.747474747474748), (629.63573591741, 0.757575757575758), (
    629.642307793437, 0.767676767676768), (629.648207605805, 
    0.777777777777778), (629.653504082158, 0.787878787878788), (
    629.658258921806, 0.797979797979798), (629.662527514464, 
    0.808080808080808), (629.666359585497, 0.818181818181818), (
    629.669799775175, 0.828282828282828), (629.672888158694, 
    0.838383838383838), (629.675660713016, 0.848484848484848), (
    629.678149735969, 0.858585858585859), (629.680384222491, 
    0.868686868686869), (629.682390202391, 0.878787878787879), (
    629.684191043578, 0.888888888888889), (629.685807724273, 
    0.898989898989899), (629.687259077391, 0.909090909090909), (
    629.688562009923, 0.919191919191919), (629.689731699892, 
    0.929292929292929), (629.690781773162, 0.939393939393939), (
    629.691724462165, 0.94949494949495), (629.692570748403, 0.95959595959596), 
    (629.693330490369, 0.96969696969697), (629.694012538392, 0.97979797979798), 
    (629.694624837733, 0.98989898989899), (629.695174521143, 1.0)))
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model.cae".
mdb.models['Model-1'].HomogeneousSolidSection(name='solid', 
    material='elastic-plastic', thickness=None)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
a = mdb.models['Model-1'].rootAssembly
a.DatumCsysByDefault(CARTESIAN)
p = mdb.models['Model-1'].parts['solid-single']
a.Instance(name='solid-single-1', part=p, dependent=OFF)
session.viewports['Viewport: 1'].view.setValues(nearPlane=22.6514, 
    farPlane=50.5194, width=55.9808, height=35.023, viewOffsetX=2.21853, 
    viewOffsetY=6.82692)
a = mdb.models['Model-1'].rootAssembly
del a.features['solid-single-1']
a1 = mdb.models['Model-1'].rootAssembly
p = mdb.models['Model-1'].parts['solid-single']
a1.Instance(name='solid-single-1', part=p, dependent=ON)
mdb.models['Model-1'].rootAssembly.features.changeKey(
    fromName='solid-single-1', toName='solid-single-vumat')
a1 = mdb.models['Model-1'].rootAssembly
p = mdb.models['Model-1'].parts['solid-single']
a1.Instance(name='solid-single-1', part=p, dependent=ON)
mdb.models['Model-1'].rootAssembly.features.changeKey(
    fromName='solid-single-1', toName='solid-single-compare')
session.viewports['Viewport: 1'].view.setValues(nearPlane=13.181, 
    farPlane=48.4427, width=32.9048, height=20.5861, viewOffsetX=4.10554, 
    viewOffsetY=1.99456)
session.viewports['Viewport: 1'].view.setValues(nearPlane=13.1662, 
    farPlane=48.4576, width=32.8677, height=20.5629, viewOffsetX=7.76031, 
    viewOffsetY=-2.86436)
a1 = mdb.models['Model-1'].rootAssembly
a1.translate(instanceList=('solid-single-compare', ), vector=(20.0, 0.0, 0.0))
#: The instance solid-single-compare was translated by 20., 0., 0. with respect to the assembly coordinate system
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=OFF, 
    engineeringFeatures=OFF, mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
p1 = mdb.models['Model-1'].parts['solid-single']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
p = mdb.models['Model-1'].parts['solid-single']
e = p.edges
pickedEdges = e.getSequenceFromMask(mask=('[#400 ]', ), )
p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FINER)
p = mdb.models['Model-1'].parts['solid-single']
e = p.edges
pickedEdges = e.getSequenceFromMask(mask=('[#101 ]', ), )
p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FINER)
elemType1 = mesh.ElemType(elemCode=C3D8R, elemLibrary=EXPLICIT, 
    kinematicSplit=AVERAGE_STRAIN, secondOrderAccuracy=OFF, 
    hourglassControl=DEFAULT, distortionControl=DEFAULT)
elemType2 = mesh.ElemType(elemCode=C3D6, elemLibrary=EXPLICIT)
elemType3 = mesh.ElemType(elemCode=C3D4, elemLibrary=EXPLICIT)
p = mdb.models['Model-1'].parts['solid-single']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
p = mdb.models['Model-1'].parts['solid-single']
p.generateMesh()
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model.cae".
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON, mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
p1 = mdb.models['Model-1'].parts['solid-single']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
mdb.models['Model-1'].sections.changeKey(fromName='solid', 
    toName='solid-compare')
mdb.models['Model-1'].sections.changeKey(fromName='solid-compare', 
    toName='compare')
mdb.models['Model-1'].Material(name='VUMAT')
mdb.models['Model-1'].HomogeneousSolidSection(name='vumat', material='VUMAT', 
    thickness=None)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
p1 = mdb.models['Model-1'].parts['solid-single']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=OFF, 
    engineeringFeatures=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
mdb.models['Model-1'].parts.changeKey(fromName='solid-single', 
    toName='solid-compare')
#: Warning: One or more instances of this part exists in the
#: assembly. They have been modified to refer to the renamed part.
#: Any assembly features and attributes that depend on the original
#: instance may become invalid due to this operation. You may need
#: to edit assembly attributes, sets, surfaces, and reference points.
p1 = mdb.models['Model-1'].parts['solid-compare']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
p = mdb.models['Model-1'].Part(name='solid-vumat', 
    objectToCopy=mdb.models['Model-1'].parts['solid-compare'])
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
p = mdb.models['Model-1'].parts['solid-vumat']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
region = p.Set(cells=cells, name='Set-4')
p = mdb.models['Model-1'].parts['solid-vumat']
p.SectionAssignment(region=region, sectionName='vumat', offset=0.0, 
    offsetType=MIDDLE_SURFACE, offsetField='', 
    thicknessAssignment=FROM_SECTION)
p1 = mdb.models['Model-1'].parts['solid-compare']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
p = mdb.models['Model-1'].parts['solid-compare']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
region = p.Set(cells=cells, name='Set-4')
p = mdb.models['Model-1'].parts['solid-compare']
p.SectionAssignment(region=region, sectionName='compare', offset=0.0, 
    offsetType=MIDDLE_SURFACE, offsetField='', 
    thicknessAssignment=FROM_SECTION)
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
#: Warning: Instance 'solid-single-vumat' has been modified to refer to renamed part 'solid-compare'.
#: Warning: Instance 'solid-single-compare' has been modified to refer to renamed part 'solid-compare'.
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON)
session.viewports['Viewport: 1'].view.setValues(nearPlane=58.0479, 
    farPlane=88.5138, width=32.9753, height=20.6302, cameraPosition=(44.3792, 
    -28.8083, 63.018), cameraUpVector=(0.0369574, 0.991465, 0.125024))
a = mdb.models['Model-1'].rootAssembly
f1 = a.instances['solid-single-vumat'].faces
faces1 = f1.getSequenceFromMask(mask=('[#8 ]', ), )
f2 = a.instances['solid-single-compare'].faces
faces2 = f2.getSequenceFromMask(mask=('[#8 ]', ), )
region = a.Set(faces=faces1+faces2, name='Set-1')
mdb.models['Model-1'].YsymmBC(name='symmetry-bottom', createStepName='Initial', 
    region=region, localCsys=None)
session.viewports['Viewport: 1'].view.setValues(nearPlane=56.5104, 
    farPlane=89.1642, width=32.1019, height=20.0838, cameraPosition=(52.0512, 
    29.6379, 62.6836), cameraUpVector=(-0.0804678, 0.726797, -0.682123), 
    cameraTarget=(16.3515, 4.58014, 4.76548))
session.viewports['Viewport: 1'].view.setValues(nearPlane=56.5867, 
    farPlane=89.0879, width=32.1453, height=20.1109, cameraPosition=(52.0512, 
    29.6379, 62.6836), cameraUpVector=(-0.0920695, 0.730569, -0.676604), 
    cameraTarget=(16.3515, 4.58014, 4.76548))
session.viewports['Viewport: 1'].view.setValues(nearPlane=56.6876, 
    farPlane=88.7183, width=32.2026, height=20.1468, cameraPosition=(47.9799, 
    45.5914, 55.5205), cameraUpVector=(-0.34146, 0.585629, -0.735148), 
    cameraTarget=(16.3329, 4.65308, 4.73273))
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF, adaptiveMeshConstraints=ON)
mdb.models['Model-1'].TabularAmplitude(name='Amp-1', timeSpan=TOTAL, 
    smooth=SOLVER_DEFAULT, data=((0.0, 0.0), (0.001, 1.0), (10.0, 1.0)))
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, adaptiveMeshConstraints=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF, adaptiveMeshConstraints=ON)
mdb.models['Model-1'].ExplicitDynamicsStep(name='load', previous='Initial', 
    timePeriod=0.005, adiabatic=ON, improvedDtMethod=ON)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='load')
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, adaptiveMeshConstraints=OFF)
a = mdb.models['Model-1'].rootAssembly
f1 = a.instances['solid-single-vumat'].faces
faces1 = f1.getSequenceFromMask(mask=('[#2 ]', ), )
f2 = a.instances['solid-single-compare'].faces
faces2 = f2.getSequenceFromMask(mask=('[#2 ]', ), )
region = a.Set(faces=faces1+faces2, name='Set-2')
mdb.models['Model-1'].VelocityBC(name='velocity', createStepName='load', 
    region=region, v1=UNSET, v2=100.0, v3=UNSET, vr1=UNSET, vr2=UNSET, 
    vr3=UNSET, amplitude='Amp-1', localCsys=None, distributionType=UNIFORM, 
    fieldName='')
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
mdb.Job(name='solid-uni-tens', model='Model-1', description='', type=ANALYSIS, 
    atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
    memoryUnits=PERCENTAGE, explicitPrecision=SINGLE, 
    nodalOutputPrecision=SINGLE, echoPrint=OFF, modelPrint=OFF, 
    contactPrint=OFF, historyPrint=OFF, userSubroutine='', scratch='', 
    resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, numDomains=1, 
    activateLoadBalancing=False, numThreadsPerMpiProcess=1, 
    multiprocessingMode=DEFAULT, numCpus=1)
mdb.jobs['solid-uni-tens'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "solid-uni-tens.inp".
p1 = mdb.models['Model-1'].parts['solid-compare']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
del mdb.models['Model-1'].materials['elastic-plastic'].plastic
mdb.models['Model-1'].materials['elastic-plastic'].Plastic(scaleStress=None, 
    table=((290.7, 0.0), (421.510781506789, 0.0101010101010101), (
    463.674466796805, 0.0202020202020202), (488.098529552815, 
    0.0303030303030303), (507.858160621519, 0.0404040404040404), (
    525.479091107285, 0.0505050505050505), (541.550928755265, 
    0.0606060606060606), (556.297419016244, 0.0707070707070707), (
    569.863791187663, 0.0808080808080808), (582.370307874984, 
    0.0909090909090909), (593.923108645074, 0.101010101010101), (
    604.617164105182, 0.111111111111111), (614.537692920868, 
    0.121212121212121), (623.761209000359, 0.131313131313131), (
    632.35642062559, 0.141414141414141), (640.385030175111, 0.151515151515152), 
    (647.902450706934, 0.161616161616162), (654.958449014901, 
    0.171717171717172), (661.597722880084, 0.181818181818182), (
    667.860419283512, 0.191919191919192), (673.782599624434, 
    0.202020202020202), (679.396657364752, 0.212121212121212), (
    684.731692964885, 0.222222222222222), (689.813850478639, 
    0.232323232323232), (694.666619727968, 0.242424242424242), (
    699.311107577529, 0.252525252525252), (703.766281469006, 
    0.262626262626263), (708.049188051987, 0.272727272727273), (
    712.17514945812, 0.282828282828283), (716.157939504798, 0.292929292929293), 
    (720.009941880861, 0.303030303030303), (723.742292156869, 
    0.313131313131313), (727.365005274107, 0.323232323232323), (
    730.887089997308, 0.333333333333333), (734.316651664209, 
    0.343434343434343), (737.660984428763, 0.353535353535354), (
    740.926654072382, 0.363636363636364), (744.119572347777, 
    0.373737373737374), (747.24506372128, 0.383838383838384), (750.30792529099, 
    0.393939393939394), (753.312480578614, 0.404040404040404), (
    756.262627821488, 0.414141414141414), (759.161883327185, 
    0.424242424242424), (762.013420395638, 0.434343434343434), (
    764.820104262046, 0.444444444444444), (767.584523467474, 
    0.454545454545455), (770.309018022464, 0.464646464646465), (
    772.995704691604, 0.474747474747475), (775.646499693469, 
    0.484848484848485), (778.263139080235, 0.494949494949495), (
    780.847197034243, 0.505050505050505), (783.40010229453, 0.515151515151515), 
    (785.923152904554, 0.525252525252525), (788.417529452772, 
    0.535353535353535), (790.88430696021, 0.545454545454546), (
    793.324465553367, 0.555555555555556), (795.738900046659, 
    0.565656565656566), (798.128428545925, 0.575757575757576), (
    800.493800173073, 0.585858585858586), (802.83570200176, 0.595959595959596), 
    (805.154765284752, 0.606060606060606), (807.451571045422, 
    0.616161616161616), (809.726655098377, 0.626262626262626), (
    811.980512557603, 0.636363636363636), (814.21360188452, 0.646464646464646), 
    (816.426348522997, 0.656565656565657), (818.619148163545, 
    0.666666666666667), (820.792369674623, 0.676767676767677), (
    822.94635773507, 0.686868686868687), (825.081435198238, 0.696969696969697), 
    (827.197905215241, 0.707070707070707), (829.296053141957, 
    0.717171717171717), (831.376148251883, 0.727272727272727), (
    833.438445274702, 0.737373737373737), (835.483185778357, 
    0.747474747474748), (837.51059941065, 0.757575757575758), (
    839.520905014716, 0.767676767676768), (841.514311631254, 
    0.777777777777778), (843.491019399114, 0.787878787878788), (
    845.451220364592, 0.797979797979798), (847.3950992088, 0.808080808080808), 
    (849.32283390145, 0.818181818181818), (851.234596288595, 
    0.828282828282828), (853.130552621055, 0.838383838383838), (
    855.010864029604, 0.848484848484848), (856.875686952344, 
    0.858585858585859), (858.725173519156, 0.868686868686869), (
    860.559471897602, 0.878787878787879), (862.378726604232, 
    0.888888888888889), (864.183078784804, 0.898989898989899), (
    865.972666466612, 0.909090909090909), (867.74762478575, 0.919191919191919), 
    (869.508086191881, 0.929292929292929), (871.254180632806, 
    0.939393939393939), (872.98603572088, 0.94949494949495), (874.703776883138, 
    0.95959595959596), (876.407527496788, 0.96969696969697), (878.097409011562, 
    0.97979797979798), (879.773541060255, 0.98989898989899), (881.436041558668, 
    1.0)))
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model.cae".
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.jobs['solid-uni-tens'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "solid-uni-tens.inp".
import os
os.chdir(
    r"/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey-Shell")
mdb.jobs['solid-uni-tens'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "solid-uni-tens.inp".
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model.cae".
mdb.save()
#: The model database has been saved to "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/MJC-Hershey/Model.cae".
