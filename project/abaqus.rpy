# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-19.57.30 176069
# Run by anders on Fri Dec  8 11:13:35 2023
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
#: The model database "/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/Model.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p = mdb.models['SolidSingle-BiTens'].parts['solid-compare']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].setValues(displayedObject=None)
o1 = session.openOdb(
    name='/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/solid-uni-tens.odb')
session.viewports['Viewport: 1'].setValues(displayedObject=o1)
#: Model: /home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/solid-uni-tens.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     2
#: Number of Meshes:             2
#: Number of Element Sets:       4
#: Number of Node Sets:          4
#: Number of Steps:              1
odb = session.odbs['/home/anders/Documents/H2023/PlasticityTheory/PlasticityProject/project/verification/solid-uni-tens.odb']
xyList = xyPlot.xyDataListFromField(odb=odb, outputPosition=INTEGRATION_POINT, 
    variable=(('S', INTEGRATION_POINT, ((INVARIANT, 'Mises'), )), ), 
    elementPick=(('SOLID-VUMAT', 1, ('[#1 ]', )), ), )
xyp = session.XYPlot('XYPlot-1')
chartName = xyp.charts.keys()[0]
chart = xyp.charts[chartName]
curveList = session.curveSet(xyData=xyList)
chart.setValues(curvesToPlot=curveList)
session.charts[chartName].autoColor(lines=True, symbols=True)
session.viewports['Viewport: 1'].setValues(displayedObject=xyp)
cliCommand("""session.xyDataObjects['_S:Mises PI: SOLID-VUMAT E: 1 IP: 1'].data""")
#: ((0.0, 0.0), (0.000125937425764278, 49.9624443054199), (0.00025086072855629, 198.157318115234), (0.000375839037587866, 306.008117675781), (0.00050070317229256, 335.627777099609), (0.000625565298832953, 365.812377929688), (0.000750424573197961, 393.5283203125), (0.000875279889442027, 417.159973144531), (0.00100012985058129, 436.511932373047), (0.00112598738633096, 451.641510009766), (0.00125082093290985, 463.287658691406), (0.00137564400210977, 472.988464355469), (0.00150045508053154, 481.514312744141), (0.00162525242194533, 489.289520263672), (0.00175003474578261, 496.549041748047), (0.00187581474892795, 503.4794921875), (0.00200056214816868, 510.045379638672), (0.00212528998963535, 516.349365234375), (0.00225101038813591, 522.468383789062), (0.00237569445744157, 528.323364257812), (0.00250035454519093, 533.978576660156), (0.00262600253336132, 539.488891601562), (0.0027506104670465, 544.774963378906), (0.00287519046105444, 549.890075683594), (0.00300075369887054, 554.881469726562), (0.00312527338974178, 559.675537109375), (0.0032507732976228, 564.356994628906), (0.00337522779591382, 568.856384277344), (0.0035006592515856, 573.252990722656), (0.00362504343502223, 577.481384277344), (0.00375040178187191, 581.615783691406), (0.00387572171166539, 585.626586914062), (0.0040010018274188, 589.5185546875), (0.00412523094564676, 593.266540527344), (0.00425042863935232, 596.935974121094), (0.00437558302655816, 600.500244140625), (0.00450069317594171, 603.963500976562), (0.00462575815618038, 607.329772949219), (0.00475077703595161, 610.602722167969), (0.00487574841827154, 613.7861328125), (0.00499999988824129, 616.866882324219))
