# encoding: utf-8

require "cheetah"

def print_exception(e)
  result = ""

  if e.is_a?(Cheetah::ExecutionFailed)
    result << "#{e.message}\n"
    result << "\n"

    if !e.stdout.empty?
      result << "Standard output:\n"
      result << "#{e.stdout}\n"
    else
      result << "Standard output: (none)\n"
    end

    if !e.stderr.empty?
      result << "Error output:\n"
      result << "#{e.stderr}\n"
    else
      result << "Error output:    (none)\n"
    end
  else
    result << "#{e.class}: #{e.message} \n"
    result << "\n"
    result << "Backtrace:\n"
    e.backtrace.each do |line|
      result << "  #{line}\n"
    end
  end

  result
end
