require "../common/project"

class StaticBuilder < Barista::Project
  include Common::Project
  file("apache_license", "#{__DIR__}/../../../LICENSE")

  @@name = "crystal-static"

  def initialize
    super

    description("Static build of Crystal (no deps)")
  end

  def extra_config
    if platform.family.eql? "debian"
      runtime_dependency("libevent-dev")
      runtime_dependency("libpcre3-dev")
      runtime_dependency("libxml2-dev")
      runtime_dependency("libyaml-dev")
      runtime_dependency("libz-dev")
      runtime_dependency("libssl-dev")
      runtime_dependency("libgmp-dev")
      runtime_dependency("libgmpxx4ldbl")
    elsif platform.family.eql? "fedora"
      runtime_dependency("libedit-devel")
      runtime_dependency("libevent-devel")
      runtime_dependnecy("libxml2-devel")
      runtime_dependency("libyaml-devel")
      runtime_dependency("openssl-devel")
      runtime_dependency("pcre-devel")
    end
  end
end