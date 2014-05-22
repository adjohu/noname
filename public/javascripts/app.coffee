window.addEventListener 'gamepadconnected', (e) ->
  console.log('gamepad connected', e)

class Game
  constructor: ->
    [w,h] = @getWindowSize()

    @scene = new THREE.Scene

    @createRenderer w, h
    @createCamera w,h
    @createGamepad()

    @createFloor()

    @tick()
    console.log @scene

  tick: ->
    @pollGamepad()
    window.requestAnimationFrame => @tick();
    @render()

  render: ->
    @renderer.render @scene, @camera

  createRenderer: (w,h) ->
    @renderer = new THREE.WebGLRenderer
    @renderer.setClearColor 0xffffff, 1
    @renderer.setSize w, h
    document.body.appendChild @renderer.domElement

  createFloor: ->
    geometry = new THREE.PlaneGeometry 200,200,1,1
    material = new THREE.MeshBasicMaterial color: 0x0000ff
    @floor = new THREE.Mesh geometry, material
    @scene.add @floor

    @camera.lookAt @floor.position

  createCamera: (w,h) ->
    @camera = new THREE.PerspectiveCamera 75, w/h, 0.1, 1000
    @camera.position.z = 100
    window.c = @camera


  createGamepad: ->
    @gamepad = navigator.webkitGetGamepads && navigator.webkitGetGamepads()[0]

  pollGamepad: ->
    stickThreshold = 0.1
    invert = true

    if @createGamepad()
      window.g = @gamepad
      [x,y,h,v] = @gamepad.axes

      # Movement
      if Math.abs(x) > stickThreshold
        @camera.translateX(x)
      if Math.abs(y) > stickThreshold
        @camera.translateZ(y)

      # Rotation
      top = 1
      bottom = 0
      if Math.abs(v) > stickThreshold
        if invert
          v *= -1
        crx = @camera.rotation.x
        crx -= v/10
        crx = bottom if crx<bottom
        crx = top if crx > top
        @camera.rotation.x = crx

      if Math.abs(h) > stickThreshold
        @camera.rotation.y -= h / 10


  getWindowSize: ->
    [window.innerWidth, window.innerHeight]




new Game