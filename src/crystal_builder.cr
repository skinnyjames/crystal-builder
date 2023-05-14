require "barista"
require "./crystal_builder/version"
require "./crystal_builder/cli/*"
require "./crystal_builder/common/task"
require "./crystal_builder/projects/*"
require "./crystal_builder/tasks/*"

project_map = [FullBuilder, QuickBuilder, StaticBuilder].reduce({} of String => Common::Project) do |memo, klass|
  p = klass.new
  memo[p.name] = p.as(Common::Project)
  memo
end

console = ACON::Application.new("crystal-builder")
console.add(Cli::Build.new(project_map))
console.run