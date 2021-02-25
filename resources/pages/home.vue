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
        <div class="col-12 col-md-8 offset-md-2">
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
  </div>
</template>

<script>
import Map from 'ol/Map'
import TileLayer from 'ol/layer/Tile'
import View from 'ol/View'
import Geolocation from 'ol/Geolocation'
import Point from 'ol/geom/Point'
import Feature from 'ol/Feature'
import VectorLayer from 'ol/layer/Vector'
import { Style, Icon} from 'ol/style'
import {OSM, Vector as VectorSource} from 'ol/source'

export default {
  name: 'Home',
  data() {
    return {
      map: null,
      geolocation: null,
      mapView: null,
      sidebarVisible: false,
      usersBarVisible: false
    }
  },
  // TODO : Fix code
  mounted() {
    const vm = this
    
    const view = new View({
      zoom: 19,
      maxZoom: 19,
      center: [0, 0]
    })

    const map = new Map({
      layers: [
        new TileLayer({
        source: new OSM({
          tiles: 'https://maps.geoapify.com/v1/styles/osm-bright/style.json?apiKey=141a66049e494053ba423db6db54893b'
        })
        })
      ],
      target: 'map',
      view: view
    })

    if (navigator.geolocation) {
      const geolocation = new Geolocation({
        trackingOptions: {
          enableHighAccuracy: true
        },
        projection: view.getProjection()
      })

      geolocation.setTracking(true)

      var accuracyFeature = new Feature()
      geolocation.on('change:accuracyGeometry', function () {
        accuracyFeature.setGeometry(geolocation.getAccuracyGeometry())
      })

      var positionFeature = new Feature();
      positionFeature.setStyle(
        new Style({
          image: new Icon({
            src: 'https://api.geoapify.com/v1/icon/?type=awesome&color=red&icon=user&apiKey=141a66049e494053ba423db6db54893b',
            imgSize: [100, 100]
          }),
        })
      );

      geolocation.on('change:position', function () {
        var coordinates = geolocation.getPosition();
        positionFeature.setGeometry(coordinates ? new Point(coordinates) : null)
        map.getView().setCenter(coordinates)
      });

      new VectorLayer({
        map: map,
        source: new VectorSource({
          features: [positionFeature],
        }),
      })
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
</style>