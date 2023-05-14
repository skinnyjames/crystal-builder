require "../common/project"

class QuickBuilder < Barista::Project
  include Common::Project
  file("apache_license", "#{__DIR__}/../../../LICENSE")

  @@name = "crystal-quick"

  def initialize
    super

    description("Quick build of Crystal (runtime deps)")
    extra_config
  end

  def extra_config
    if platform.family ==  "debian"
      runtime_dependency("libevent-dev")
      runtime_dependency("libpcre2-dev")
      runtime_dependency("libxml2-dev")
      runtime_dependency("libyaml-dev")
      runtime_dependency("libz-dev")
      runtime_dependency("libssl-dev")
      runtime_dependency("libgmp-dev")
      runtime_dependency("libgmpxx4ldbl")
      runtime_dependency("libstdc++6")
      runtime_dependency("libgc-dev")
      runtime_dependency("llvm")
    elsif platform.family == "fedora"
      runtime_dependency("libedit-devel")
      runtime_dependency("libevent-devel")
      runtime_dependency("libxml2-devel")
      runtime_dependency("libyaml-devel")
      runtime_dependency("openssl-devel")
      runtime_dependency("pcre2-devel")
      runtime_dependency("llvm15-devel")
      runtime_dependency("llvm15-static")
      runtime_dependency("libstdc++-static") 
      runtime_dependency("gc-devel")
      runtime_dependency("libffi-devel")
    end
  end
end