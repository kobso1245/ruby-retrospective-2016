class Hash
  def convert
    {
      Hash => -> (key, val) { ([key.to_sym, key] & val.keys).first },
      Array => -> (key, _) { key.to_i if key.to_i.to_s == key },
      nil => nil
    }
  end

  def key_value
    {
      Hash => -> (strct) { strct.flatten },
      Array => -> (strct) { strct.map.with_index(&:reverse) },
      nil => []
    }
  end

  def fetch_deep(path)
    parsed_path = path.split('.')
    fetch_rec(parsed_path, self)
  end

  def fetch_rec(path, strct)
    key = path.shift
    strct_type = ([Hash, Array].include? strct.class) ? strct.class : nil
    return nil unless strct_type
    return strct[convert[strct_type].call(key, strct)] if path.empty?
    fetch_rec(path, strct[convert[strct_type].call(key, strct)])
  end

  def reshape(shape)
    new_h = {}
    elems = key_value[Hash].call(shape)
    elems.each { |key, _| reshape_rec(key, shape, self, new_h) }
    new_h
  end

  def reshape_rec(key, sh, order, new_h)
    type = ([Hash, Array, String].include? sh[key].class) ? sh[key].class : nil
    if type == String
      new_h[key] = order.fetch_deep(sh[key])
    elsif type
      elems = key_value[type].call(sh[key])
      new_h[key] = sh[key].dup
      elems.each { |new_k, _| reshape_rec(new_k, sh[key], order, new_h[key]) }
    end
  end
end

class Array
  def reshape(shape)
    map { |value| value.reshape(shape) }
  end
end
