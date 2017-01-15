def extract_params(val)
  stripped = val.tr('-', '')
  if val[0..1] == '--'
    return (val.include? '=') ? stripped.split('=') : [stripped, true]
  elsif val[0] == '-'
    return (val.size > 2) ? [stripped[0], stripped[1..-1]] : [stripped, true]
  else
    return ['argument']
  end
end

def optionize(elems, cmd_runner, val_ind)
  command, value = val_ind
  elems.select { |cmd| cmd.include? command }.first[-1].call(cmd_runner, value)
end

def add_elem(struct, arguments, block)
  struct.push(arguments)
  struct[-1].push(block) if block
end

class CommandParser
  def initialize(command_name)
    @cmd = command_name
    @opts = []
    @opts_with_pars = []
    @args = []
    @parsed = {}
  end

  def argument(argument, &block)
    add_elem(@args, [argument], block)
  end

  def option(sh_name, l_name, hlp, &block)
    add_elem(@opts, [sh_name, l_name, hlp], block)
  end

  def option_with_parameter(sh_name, l_name, hlp, value, &block)
    add_elem(@opts_with_pars, [sh_name, l_name, hlp, value], block)
  end

  def help
    out = ""
    out << "Usage: #{@cmd}" + @args.map { |arg| " [#{arg[0]}]" }.join("")
    @opts.each do |sh_v, long_v, msg|
      out << "\n    -#{sh_v}, --#{long_v} #{msg}"
    end
    @opts_with_pars.each do |sh_v, long_v, msg, param|
      out << "\n    -#{sh_v}, --#{long_v}=#{param} #{msg}"
    end
    out
  end

  def parse(command_runner, argv)
    combined_options = @opts_with_pars + @opts
    argv.each do |val|
      params = extract_params(val)
      case params.size
      when 1 then @args.shift[-1].call(command_runner, val)
      else optionize(combined_options, command_runner, params)
      end
    end
    @parsed.merge!(command_runner)
    command_runner.merge!(@parsed)
  end
end
