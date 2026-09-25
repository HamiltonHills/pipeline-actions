import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  test: {
    coverage: {
      provider: 'v8',
      // lcov is what Sonar reads (sonar.javascript.lcov.reportPaths)
      reporter: ['text', 'lcov'],
      include: ['src/**/*.js'],
    },
  },
})
