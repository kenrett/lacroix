# frozen_string_literal: true

flavors = [
  'pure',
  'lime',
  'lemon',
  'orange',
  'berry',
  'cran-raspberry',
  'pamplemousse',
  'peach-pear',
  'coconut',
  'apricot',
  'passionfruit',
  'mango',
  'tangerine',
  'key lime'
]

flavors.each do |name|
  Flavor.create(name: name)
end
