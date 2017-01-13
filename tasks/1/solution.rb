FORMULAS = {
  'CF' => ->(degrees) { (1.8 * degrees) + 32 },
  'FC' => -> (degrees) { (degrees - 32) / 1.8 },
  'CK' => -> (degrees) { degrees + 273.15 },
  'KC' => -> (degrees) { degrees - 273.15 },
  'KF' => -> (degrees) { FORMULAS['CF'].call(degrees - 273.15) },
  'FK' => -> (degrees) { (degrees - 32) / 1.8 + 273.15 },
  'CC' => -> (degrees) { degrees },
  'KK' => -> (degrees) { degrees },
  'FF' => -> (degrees) { degrees }
}.freeze

TEMPERATURES = {
	'water' => [0, 100],
	'ethanol' => [-114, 78.37],
	'gold' => [1064, 2700],
	'silver' => [961.8, 2162],
	'copper' => [1085, 2567]
}.freeze

def convert_between_temperature_units(input_degrees, input_unit, output_unit)
	FORMULAS[input_unit + output_unit].call(input_degrees).round(2)
end

def melting_point_of_substance(substance, output_unit)
	FORMULAS['C' + output_unit].call(TEMPERATURES[substance][0])
end

def boiling_point_of_substance(substance, output_unit)
	FORMULAS['C' + output_unit].call(TEMPERATURES[substance][1])
end
