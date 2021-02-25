<template>
  <div>
    <div id="map" class="map"></div>
    <b-sidebar shadow id="main-sidebar" v-model="sidebarVisible" title="ShareLoc"></b-sidebar>
    <div class="content">
      <div class="row">
        <div class="col-12 col-md-8 offset-md-2">
          <!-- Search -->
          <div class="card">
            <div class="card-header">
              <div class="input-group">
                <div class="input-group-addon">
                  <button class="btn" @click="sidebarVisible = !sidebarVisible">
                    <i class="fa fa-bars"></i>
                  </button>
                </div>
                <input type="text" class="form-control" placeholder="Search Location....">
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
import OSM from 'ol/source/OSM'
import TileLayer from 'ol/layer/Tile'
import View from 'ol/View'

export default {
  name: 'Home',
  data() {
    return {
      map: null,
      sidebarVisible: false
    }
  },
  mounted() {
    this.map = new Map({
      layers: [
        new TileLayer({
          source: new OSM(),
        }) ],
      target: 'map',
      view: new View({
        center: [0, 0],
        zoom: 2,
      }),
    })
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
  min-width: 100vw;
  min-height: 100vh;
  top: 0%;
  left: 0%;
}
</style>