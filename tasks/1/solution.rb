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
  'water' => {
    melting_point: 0,
    boiling_point: 100
  },
  'ethanol' => {
    melting_point: -114,
    boiling_point: 78.37
  },
  'gold' => {
    melting_point: 1_064,
    boiling_point: 2_700
  },
  'silver' => {
    melting_point: 961.8,
    boiling_point: 2_162
  },
  'copper' => {
    melting_point: 1_085,
    boiling_point: 2_567
  }
}.freeze

def convert_between_temperature_units(input_degrees, input_unit, output_unit)
  FORMULAS[input_unit + output_unit].call(input_degrees).round(2)
end

def melting_point_of_substance(substance, output_unit)
  FORMULAS['C' + output_unit].call(TEMPERATURES[substance][:melting_point])
end

def boiling_point_of_substance(substance, output_unit)
  FORMULAS['C' + output_unit].call(TEMPERATURES[substance][:boiling_point])
end
