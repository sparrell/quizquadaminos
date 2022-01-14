module.exports = {
  mode: 'jit', // https://tailwindcss.com/docs/just-in-time-mode
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
     fontFamily: {
      'sans': ['Helvetica']},
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}