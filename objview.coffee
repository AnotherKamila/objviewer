view_conf =
    width:  $('#view').width()
    height: $('#view').height()
    fov:  Math.PI/2
    near: 0.1
    far:  100000

load_obj = (cb) ->
    url = window.location.hash.match(/url=([^&]*)/)[1] ? 'test.obj'
    $('#messages').text "Loading OBJ file..."
    $.get url, (data, status) ->
        object = ((new THREE.OBJLoader()).parse data).children[0]
        mesh = new THREE.SceneUtils.createMultiMaterialObject object.geometry,
                        [ new THREE.MeshLambertMaterial(color: 0xaaaaff, opacity: 0.5),
                          new THREE.MeshBasicMaterial(color: 0x000000, transparent: true, wireframe: true, opacity: 0.2) ]
        scale = 1/mesh.children[0].geometry.boundingSphere.radius  # normalize size
        mesh.scale = new THREE.Vector3 scale, scale, scale

        cb mesh

init = (mesh) ->
    container = $(document.body)

    renderer = new THREE.WebGLRenderer()
    renderer.setSize view_conf.width, view_conf.height
    $('#view').append renderer.domElement

    scene = new THREE.Scene()
    window.scene = scene  # TODO remove me!

    camera = new THREE.PerspectiveCamera view_conf.fov, view_conf.width/view_conf.height, view_conf.near, view_conf.far
    camera.position.z = 100
    camera.lookAt scene.position
    scene.add camera

    light = new THREE.PointLight 0xffffff
    light.position = { x: 20, y: 70, z: 150 }
    scene.add light

    sphere = new THREE.Mesh (new THREE.SphereGeometry 1, 32, 32), (new THREE.MeshBasicMaterial color: 0x00ff00, opacity: 0.2)
    # scene.add sphere

    scene.add mesh

    controls = new THREE.TrackballControls camera
    controls.panSpeed = 0.05
    controls.noPan = false
    controls.noZoom = false

    animate = ->
        renderer.render scene, camera  # TODO loop via requestAnimationFrame
        controls.update()
        requestAnimationFrame animate
    $('#messages').text 'Controls: Left mouse button: rotate, Right mouse button: pan, Wheel: zoom'
    animate()




load_obj init