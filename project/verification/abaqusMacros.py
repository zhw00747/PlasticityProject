# -*- coding: mbcs -*-
# Do not delete the following import lines
from abaqus import *
from abaqusConstants import *
import __main__

def set_view():
    import section
    import regionToolset
    import displayGroupMdbToolset as dgm
    import part
    import material
    import assembly
    import step
    import interaction
    import load
    import mesh
    import optimization
    import job
    import sketch
    import visualization
    import xyPlot
    import displayGroupOdbToolset as dgo
    import connectorBehavior
    session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
    session.viewports['Viewport: 1'].view.setValues(nearPlane=20.8773, 
        farPlane=48.4047, width=75.234, height=40.158, cameraPosition=(27.349, 
        23.2757, 24.3753), cameraTarget=(7.34901, 3.27571, 4.37527))
    session.viewports['Viewport: 1'].view.setValues(nearPlane=20.7732, 
        farPlane=48.5088, cameraPosition=(35.1288, 32.9855, 6.88575), 
        cameraTarget=(15.1288, 12.9855, -13.1142))
    session.viewports['Viewport: 1'].view.setValues(width=74.4816, height=39.7564, 
        cameraPosition=(35.0127, 32.9195, 7.06784), cameraTarget=(15.0127, 
        12.9195, -12.9321))
    session.graphicsOptions.setValues(backgroundStyle=SOLID, 
        backgroundColor='#FFFFFF')
    session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])


def overlay_plot():
    import section
    import regionToolset
    import displayGroupMdbToolset as dgm
    import part
    import material
    import assembly
    import step
    import interaction
    import load
    import mesh
    import optimization
    import job
    import sketch
    import visualization
    import xyPlot
    import displayGroupOdbToolset as dgo
    import connectorBehavior
    leaf = dgo.LeafFromPartInstance(partInstanceName=('COMPARE', ))
    session.viewports['Viewport: 1'].odbDisplay.displayGroup.remove(leaf=leaf)
    session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
        CONTOURS_ON_UNDEF, CONTOURS_ON_DEF, ))
    session.viewports['Viewport: 1'].view.setValues(session.views['Left'])
    session.viewports['Viewport: 1'].view.setValues(nearPlane=30.3635, 
        farPlane=44.281, width=28.8759, height=15.4132, cameraPosition=(
        -32.3222, 5.21087, 6.33988), cameraTarget=(5, 5.21087, 6.33988))
    session.viewports['Viewport: 1'].view.setValues(cameraPosition=(-32.3222, 
        3.7403, 8.6444), cameraTarget=(5, 3.7403, 8.6444))
    session.viewports['Viewport: 1'].view.setValues(nearPlane=28.1987, 
        farPlane=49.2084, cameraPosition=(-23.2492, 10.4243, 32.1018), 
        cameraUpVector=(0.241508, 0.970293, 0.0143631))
    session.viewports['Viewport: 1'].view.setValues(nearPlane=26.7473, 
        farPlane=50.6597, width=50.8612, height=27.1484, cameraPosition=(
        -25.1142, 13.4808, 28.9849), cameraTarget=(3.135, 6.7968, 5.5275))
    session.viewports['Viewport: 1'].view.setValues(cameraUpVector=(0.182452, 
        0.981387, -0.0599178), cameraTarget=(3.135, 6.7968, 5.5275))
    leaf = dgo.LeafFromPartInstance(partInstanceName=('COMPARE', ))
    session.viewports['Viewport: 1'].odbDisplay.displayGroup.remove(leaf=leaf)
    session.viewports['Viewport: 1'].view.setValues(session.views['Left'])
    session.viewports['Viewport: 1'].view.setValues(nearPlane=30.0659, 
        farPlane=44.5785, width=33.2624, height=17.7546, cameraPosition=(
        -32.3222, 5.2318, 0.889304), cameraTarget=(5, 5.2318, 0.889304))
    session.viewports['Viewport: 1'].view.setValues(cameraPosition=(-32.3222, 
        4.08119, 10.836), cameraTarget=(5, 4.08119, 10.836))
    session.viewports['Viewport: 1'].view.setValues(cameraPosition=(-32.3222, 
        3.80952, 7.18993), cameraTarget=(5, 3.80952, 7.18993))
    session.viewports['Viewport: 1'].view.setValues(cameraPosition=(-32.3222, 
        3.80952, 11.1718), cameraTarget=(5, 3.80952, 11.1718))


def overlay_plot_biax():
    import section
    import regionToolset
    import displayGroupMdbToolset as dgm
    import part
    import material
    import assembly
    import step
    import interaction
    import load
    import mesh
    import optimization
    import job
    import sketch
    import visualization
    import xyPlot
    import displayGroupOdbToolset as dgo
    import connectorBehavior
    session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
        CONTOURS_ON_UNDEF, CONTOURS_ON_DEF, ))
    session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
    session.viewports['Viewport: 1'].view.setProjection(projection=PERSPECTIVE)
    session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
    session.viewports['Viewport: 1'].view.setValues(session.views['Front'])
    session.viewports['Viewport: 1'].view.setValues(nearPlane=34.255, 
        farPlane=48.7144, width=32.8637, height=17.545, cameraPosition=(
        5.01825, 5.30168, 46.4847), cameraTarget=(5.01825, 5.30168, 5))
    session.viewports['Viewport: 1'].view.setValues(cameraPosition=(5.41324, 
        3.62772, 46.4847), cameraTarget=(5.41324, 3.62772, 5))


