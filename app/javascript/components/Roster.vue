<template>
  <div id="roster">
    <transition name="fade-up" mode='out-in'>
      <component v-bind:is="layout"></component>
    </transition>
  </div>
</template>


<script type="text/javascript">
import { mapGetters, mapActions } from 'vuex'
import Loader from './Loader.vue'
import Layout from './Layout.vue'

export default {
  components: { Loader, Layout },
  computed: {
    ...mapGetters({
      isLoading: 'loadingState'
    }),
    layout () {
      return this.isLoading ? 'loader' : 'layout'
    }
  },
  methods: {
    ...mapActions([
      'setLoadingState'
    ]),
  },
  created () {
    this.$store.dispatch('loadTeam'),
    this.$store.dispatch('loadStats'),
    this.setLoadingState(false)
  }
}
</script>

<style>

</style>
