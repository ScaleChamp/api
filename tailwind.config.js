const colors = {
  'grey': '#697386',
  'grey-100': '#3c4257',
  'gray-1000': '#171c26',
  'gray-1100': '#11151c',
  'gray-450': '#c8cacc',
  'primary': '#0054ff',
  'primary-100': '#002eff',
  'secondary': '#2874d2',
  'bravo': '#d86664',
  'dark': '#0d2a4e'
}

module.exports = {
  purge: {
    enabled: process.env.NODE_ENV === 'production',
    content: ['./app/javascript/dashboard/**/*.vue']
  },
  corePlugins: {
    textDecoration: false,
    objectFit: false,
    borderOpacity: false,
    skew: false,
    accessibility: false
  },
  theme: {
    extend: {
      backgroundColor: theme => ({
        ...theme('colors'),
        ...colors
      }),
      borderColor: theme => ({
        ...theme('colors'),
        default: theme('colors.gray.300', 'currentColor'),
        ...colors
      }),
      textColor: theme => ({
        ...theme('colors'),
        ...colors
      }),
      fontFamily: {
        sans: ['Gilroy', 'sans-serif']
      },
      lineHeight: {
        'almost-none': '0.1'
      },
      fontSize: {
        '7xl': '5rem'
      },
      margin: {
        '11': '2.75rem'
      }
    }
  },
  variants: {
    display: ['responsive', 'hover', 'group-hover'],
    backgroundColor: ['responsive', 'hover', 'focus', 'active', 'group-hover', 'disabled'],
    opacity: ['responsive', 'hover', 'focus', 'active', 'group-hover', 'disabled'],
    borderWidth: ['responsive', 'hover', 'focus'],
    borderColor: ['responsive', 'hover', 'focus', 'disabled'],
    textColor: ['group-hover', 'responsive', 'hover', 'focus', 'disabled']
  },
  plugins: []
}
