<template>
  <div>
    <!-- Map -->
    <div id="map" class="map"></div>
    
    <!-- Sidebar Menu -->
    <b-sidebar shadow id="main-sidebar" v-model="sidebarVisible" title="ShareLoc">
      <!-- Menu -->
      <b-list-group>
        <!-- Your Locations -->
        <b-list-group-item>
          <i class="fa fa-map-marker"></i> &nbsp;
          Your Locations
        </b-list-group-item>
        <!-- User Profile -->
        <b-list-group-item>
          <i class="fa fa-user-tie"></i> &nbsp;
          User Profile
        </b-list-group-item>
        <!-- Logout -->
        <b-list-group-item rel="nofollow" data-method="DELETE" tag="a" href="/users/sign_out">
          <i class="fa fa-sign-out-alt"></i> &nbsp;
          Logout
        </b-list-group-item>
      </b-list-group>
    </b-sidebar>

    <!-- Sidebar Users -->
    <b-sidebar shadow right id="user-sidebar" v-model="usersBarVisible" title="Users List">

    </b-sidebar>

    <!-- Content -->
    <div class="content">
      <div class="row">
        <div class="col-12 col-md-6 offset-md-3">
          <!-- Search -->
          <div class="card">
            <div class="card-header">
              <div class="input-group">
                <!-- Menu Toggle -->
                <div class="input-group-addon">
                  <button class="btn btn-outlined" @click="sidebarVisible = !sidebarVisible">
                    <i class="fa fa-bars"></i>
                  </button>
                </div>
                <!-- Search Box -->
                <input type="text" class="form-control" placeholder="Search Location....">
                <!-- Active Users -->
                <div class="input-group-addon">
                  <button class="btn" @click="usersBarVisible = !usersBarVisible">
                    <i class="fa fa-users"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Focus Current Location -->
    <div class="focus-btn">
      <button @click="focusToLocation" class="btn rounded-circle btn-xl btn-light">
        <i class="fas fa-crosshairs"></i>
      </button>
    </div>
  </div>
</template>

<script>
import Map from 'ol/Map'
import View from 'ol/View'
import TileLayer from 'ol/layer/Tile'
import OSM from 'ol/source/OSM'
import ScaleLine from 'ol/control/ScaleLine'
import Feature from 'ol/Feature'
import Geolocation from 'ol/Geolocation'
import Style from 'ol/style/Style'
import Circle from 'ol/style/Circle'
import TextStyle from 'ol/style/Text'
import Stroke from 'ol/style/Stroke'
import Fill from 'ol/style/Fill'
import Point from 'ol/geom/Point'
import VectorLayer from 'ol/layer/Vector'
import VectorSource from 'ol/source/Vector'
import Modify from 'ol/interaction/Modify'
import * as interactions from 'ol/interaction'
import * as eventConditions from 'ol/events/condition'
 
export default {
  name: 'Home',
  data() {
    return {
      map: new Map({
        layers: [
          new TileLayer({
            source: new OSM()
          })
        ],
        view: new View({
          center: [0, 0],
          zoom: 15,
          maxZoom: 20
        }),
        controls: [new ScaleLine()],
        interactions: [
          new interactions.DragRotate(),
          new interactions.DragPan(),
          new interactions.PinchRotate(),
          new interactions.PinchZoom(),
          new interactions.KeyboardPan(),
          new interactions.KeyboardZoom(),
          new interactions.MouseWheelZoom(),
          new interactions.DragZoom()
        ]
      }),
      geoLocation: new Geolocation({
        trackingOptions: {
          enableHighAccuracy: true
        },
        tracking: true
      }),
      vectorLayer: new VectorLayer({style: function(feature, resolution) {
        const name = feature.get('name')
        if (name === 'position') {
          return new Style({
            image: new Circle({
              radius: 10,
              fill: new Fill({
                color: '#3399CC',
              }),
              stroke: new Stroke({
                color: '#fff',
                width: 2,
              })
            })
          })
        } else {
          return new Style({
            text: new TextStyle({
              text: '\uf3c5',
              scale: 1.5,
              textBaseline: 'bottom',
              font: '900 16px "Font Awesome 5 Free"',
              fill: new Fill({ color: '#ec4646' }),
              stroke: new Stroke({ color: 'black', width: 1 })
            })
          })
        }
      }}),
      vectorSource: new VectorSource(),
      positionFeature: new Feature({name: 'position', id: 'position'}),
      sidebarVisible: false,
      usersBarVisible: false
    }
  },
  mounted() {
    const vm = this
    Promise.resolve()
      .then(() => vm.map.setTarget('map'))
      .then(() => vm.geoLocation.setProjection(vm.map.getView().getProjection()))
      .then(() => vm.map.addLayer(vm.vectorLayer))
      .then(() => vm.vectorLayer.setSource(vm.vectorSource))
      .then(() => vm.vectorSource.addFeature(vm.positionFeature))
      .then(() => vm.listenLocationChange())
      .then(() => vm.listenMapDblClick())
      .then(() => vm.focusToLocation())
      .then(() => vm.listenModify())
      .then(() => vm.listenSelect())
  },
  methods: {
    listenSelect() {
      const vm = this
      const select = new interactions.Select({
        condition: eventConditions.pointerMove
      })

      // TODO : Add Popup When Selected
      select.on('select', (e) => console.log(e))

      vm.map.addInteraction(select)
    },
    listenModify() {
      const vm = this
      const modify = new Modify({
        hitDetection: vm.vectorLayer,
        source: vm.vectorSource,
      });

      const target = vm.map.getTargetElement()

      modify.on(['modifystart', 'modifyend'], function (evt) {
        target.style.cursor = evt.type === 'modifystart' ? 'grabbing' : 'pointer'

        if (evt.type === 'modifyend') {
          if(evt.features.item(0).get('id') !== 'position') {
            // TODO : Update Code
            alert('want to share this location ?')
          }
        }
      })

      modify.on('click', (evt) => {
        alert('click')
      })

      var overlaySource = modify.getOverlay().getSource();
      overlaySource.on(['addfeature', 'removefeature'], function (evt) {
        target.style.cursor = evt.type === 'addfeature' ? 'pointer' : ''
      })

      vm.map.addInteraction(modify)
    },
    listenMapDblClick() {
      const vm = this

      vm.map.on('dblclick', (e) => {
        const feature = new Feature()
        feature.setGeometry(new Point(e.coordinate))
        vm.vectorLayer.getSource().addFeature(feature)
      })
    },
    listenLocationChange() {
      const vm = this

      if (vm.geoLocation !== null) {
        vm.geoLocation.on('change:position', () => {
          const coords = vm.geoLocation.getPosition()
          vm.positionFeature.setGeometry(coords ? new Point(coords) : null)
        })
      }
    },
    focusToLocation() {
      const vm = this
      if (vm.geoLocation !== null) {
        setTimeout(() => {
          const initCoords = vm.geoLocation.getPosition()
          vm.positionFeature.setGeometry(new Point(initCoords))
          const view = vm.map.getView()
          view.animate({zoom: 15}, {center: initCoords, duration: 2000})
        }, 500)
      }
    },
    addNewMarker() {
      const vm = this
      // const 
    }
  }
}
</script>

<style>
.map {
  height: 100vh;
  width: 100vw;
}

.content {
  position: absolute;
  overflow: hidden;
  padding: 10px;
  min-width: 100%;
  top: 0%;
  left: 0%;
}

.focus-btn {
  position: absolute;
  overflow: hidden;
  min-width: 30px;
  bottom: 30px;
  right: 25px;
}
</style>