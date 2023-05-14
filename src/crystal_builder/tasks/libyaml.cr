@[Barista::BelongsTo(FullBuilder)]
class Tasks::LibYAML < Barista::Task
  include Common::Task
  
  @@name = "libyaml"

  dependency ConfigGuess
  #dependency Libtool
  
  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    update_config_guess(target: "config")

    command("./configure --prefix=#{install_dir}/embedded --enable-shared", env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def configure :  Nil
    license("MIT")
    license_file("License")
    version("0.2.5")
    source("https://pyyaml.org/download/libyaml/yaml-#{version}.tar.gz",
      sha256: "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4")
  end
end
