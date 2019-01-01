# frozen_string_literal: true
Flavor.destroy_all

flavors = {
  'pure' => ':la-pure:',
  'lime' => ':la-lime:',
  'lemon' => ':la-lemon:',
  'orange' => ':la-orange:',
  'berry' => ':la-berry:',
  'cran-raspberry' => ':la-cran-rasberry:',
  'pamplemousse' => ':la-pamplemousse:',
  'peach-pear' => ':la-peach-pear:',
  'coconut' => ':la-coconut:',
  'apricot' => ':la-apricot:',
  'passionfruit' => ':la-passionfruit:',
  'mango' => ':la-mango:',
  'tangerine' => ':la-tangerine:',
  'key lime' => ':la-key-lime:'
}

flavors.each do |name, emoji|
  Flavor.create(name: name, text: emoji)
  print '* '
end
