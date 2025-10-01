/** @type {import('tailwindcss').Config} */
const plugin = require('tailwindcss/plugin');
export default {
	// Watch Twig templates and any JS or JSX that might use Tailwind classes.
  content: ['./templates/**/*.twig', './src/**/*.{js,jsx,ts,tsx,svg,scss,css}'],
  theme: {
    screens: {
      '2xs': { min: '300px' },
      xs: { max: '575px' }, // Mobile (iPhone 3 - iPhone XS Max).
      sm: { min: '576px', max: '897px' }, // Mobile (matches max: iPhone 11 Pro Max landscape @ 896px).
      md: { min: '898px', max: '1199px' }, // Tablet (matches max: iPad Pro @ 1112px).
      lg: { min: '1200px' }, // Desktop smallest.
      xl: { min: '1259px' }, // Desktop wide.
      '2xl': { min: '1359px' } // Desktop widescreen.
    },
    listStyleType: {
      none: 'none',
      disc: 'disc',
      decimal: 'decimal',
      square: 'square',
      roman: 'upper-roman',
    },
    container: {
      center: true,
    },
    colors: {
      'blue': {
        50: '#eff6ff',
        100: '#dbeafe',
        200: '#bfdbfe',
        300: '#93c5fd',
        400: '#60a5fa',
        500: '#3b82f6',
        600: '#2563eb',
        700: '#1d4ed8',
        800: '#1e40af',
        900: '#1e3a8a',
      },
      'red': {
        '50': '#fff1f2',
        '100': '#ffdfe2',
        '200': '#ffc4ca',
        '300': '#ff9ba5',
        '400': '#ff6272',
        '500': '#ff3146',
        '600': '#f11128',
        '700': '#c70a1d',
        '800': '#a70d1c',
        '900': '#8a121e',
        '950': '#4c030a',
    },
    'gray': {
        '50': '#f9fafb',
        '100': '#f3f4f6',
        '200': '#e5e7eb',
        '300': '#d1d5db',
        '400': '#9ca3af',
        '500': '#6b7280',
        '600': '#4b5563',
        '700': '#374151',
        '800': '#1f2937',
        '900': '#111827',
        '950': '#030712',
    },
    'green': {
      '50': '#f0fdf4',
      '100': '#dcfce7',
      '200': '#bbf7d0',
      '300': '#86efac',
      '400': '#4ade80',
      '500': '#22c55e',
      '600': '#16a34a',
      '700': '#15803d',
      '800': '#166534',
      '900': '#14532d',
      '950': '#052e16',
    },
    'white': '#ffffff',
    'black': '#000000',
    },
    fontFamily: {
      sans: ['Inter', 'system-ui', 'sans-serif'],
      serif: ['Georgia', 'serif'],
      mono: ['Monaco', 'monospace']
    },
    extend: {
      typography: {
        DEFAULT: {
          css: {
            'figure': {
              margin: '2rem 0',
            },
            'ul, ol': {
              margin: '1.5rem 0',
            }
          }
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('tailwindcss-debug-screens'),
  ],
}
