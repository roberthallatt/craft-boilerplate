module.exports = {
  extends: ['stylelint-config-standard-scss'],
  plugins: ['stylelint-scss'],
  rules: {
    'at-rule-no-unknown': [
      true,
      {
        ignoreAtRules: [
          'tailwind',
          'apply', 
          'layer',
          'variants',
          'responsive', 
          'screen',
          'config'
        ]
      }
    ],
    'function-no-unknown': [
      true,
      {
        ignoreFunctions: ['theme', 'screen']
      }
    ],
    'scss/at-rule-no-unknown': [
      true,
      {
        ignoreAtRules: [
          'tailwind',
          'apply', 
          'layer',
          'variants',
          'responsive', 
          'screen',
          'config'
        ]
      }
    ],
    // Allow TailwindCSS class names in @apply
    'property-no-unknown': [
      true,
      {
        ignoreProperties: ['/^@apply/']
      }
    ]
  }
}