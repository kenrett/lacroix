# frozen_string_literal: true
Flavor.destroy_all

flavors = {
  'pure' => ':droplet:',
  'lime' => 'lime',
  'lemon' => ':lemon:',
  'orange' => 'orange',
  'berry' => 'berry',
  'cran-raspberry' => 'cran-rasberry',
  'pamplemousse' => ':fr:',
  'peach-pear' => ':poop:',
  'coconut' => ':coconut:',
  'apricot' => 'apricot',
  'passionfruit' => 'passionfruit',
  'mango' => 'mango',
  'tangerine' => ':tangerine:',
  'key lime' => 'key lime'
}

flavors.each do |name, emoji|
  Flavor.create(name: name, text: emoji)
  print '* '
end
