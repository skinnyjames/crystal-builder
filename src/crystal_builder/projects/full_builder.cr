require "../common/project"

class FullBuilder < Barista::Project
  include Common::Project
  file("apache_license", "#{__DIR__}/../../../LICENSE")

  @@name = "crystal-full"

  def initialize
    super

    description("Full build of Crystal (including all needed deps)")
  end
end