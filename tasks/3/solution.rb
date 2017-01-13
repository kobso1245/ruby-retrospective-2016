def determine_type(value)
  return "with_pars" if value.include? "="
  return "opt" if value[0] == '-' || value.include?("--")
  "arg"
end

def optionize(elems, val, command_runner)
  fst, sec = val.split("=")
  sec = true unless sec
  elems.each do |x|
    x[-1].call(command_runner, sec) if x.include? fst.tr('-', '')
  end
end

class CommandParser
  def initialize(command_name)
    @cmd = command_name
    @opts = []
    @with_pars = []
    @args = []
    @parsed = {}
  end

  def argument(argument, &block)
    @args.push([argument])
    @args[-1].push(block) if block_given?
  end

  def option(sh_name, l_name, hlp, &block)
    @opts.push([sh_name, l_name, hlp])
    @opts[-1].push(block) if block_given?
  end

  def option_with_parameter(sh_name, l_name, hlp, value, &block)
    @with_pars.push([sh_name, l_name, hlp, value])
    @with_pars[-1].push(block) if block_given?
  end

  def help
    out = ""
    out << "Usage: #{@cmd} " + @args.map { |x| "[#{x[0]}]" }.join(" ") + "\n"
    @opts.each { |x, y, z| out << "    -#{x}, --#{y} #{z}\n" }
    @with_pars.each { |x, y, z, p| out << "    -#{x}, --#{y}=#{p} #{z}\n" }
    out
  end

  def parse(command_runner, argv)
    with_pars_cp = @with_pars.dup
    argv.each_with_index do |val, _|
      case determine_type(val)
      when "with_pars" then optionize(with_pars_cp, val, command_runner)
      when "opt" then optionize(@opts, val, command_runner)
      when "arg" then @args.shift[-1].call(command_runner, val)
      end
    end
    @parsed.merge!(command_runner)
    command_runner.merge!(@parsed)
  end
end
