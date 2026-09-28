<script setup>
import { ref } from 'vue'
import { greet } from './utils/greet.js'

const name = ref('world')
</script>

<template>
  <main>
    <h1>{{ greet(name) }}</h1>
    <input
      v-model="name"
      aria-label="Name"
    >
  </main>
</template>
