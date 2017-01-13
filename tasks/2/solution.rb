class Hash
  def convert
    {
      Hash => -> (key, el) { [key.to_sym, key].select { |x| el.key? x }[0] },
      Array => -> (key, _) { key.to_i if key.to_i.to_s == key },
      nil => nil
    }
  end

  def key_value
    {
      Hash => -> (strct) { strct.map { |x, y| [x, y] } },
      Array => -> (strct) { strct.map.with_index { |x, i| [i, x] } },
      nil => []
    }
  end

  def fetch_deep(path)
    parsed_path = path.split('.')
    fetch_rec(parsed_path, self)
  end

  def fetch_rec(path, strct)
    key = path.shift
    strct_type = [Hash, Array].select { |n| strct.is_a? n }[0]
    return nil unless strct_type
    return strct[convert[strct_type].call(key, strct)] if path.empty?
    fetch_rec(path, strct[convert[strct_type].call(key, strct)])
  end

  def reshape(shape)
    type = Hash
    new_h = {}
    elems = key_value[type].call(shape)
    elems.each { |x, _| reshape_rec(x, shape, self, new_h) }
    new_h
  end

  def reshape_rec(key, shape, order, new_h)
    type = [Hash, Array, String].select { |n| shape[key].is_a? n }[0]
    if type == String
      new_h[key] = order.fetch_deep(shape[key])
    elsif type
      elems = key_value[type].call(shape[key])
      new_h[key] = shape[key].dup
      elems.each { |x, _| reshape_rec(x, shape[key], order, new_h[key]) }
    end
  end
end

class Array
  def reshape(shape)
    map { |x| x.reshape(shape) }
  end
end
