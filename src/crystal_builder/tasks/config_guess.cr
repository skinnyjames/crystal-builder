@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::ConfigGuess < Barista::Task
  include Common::Task

  @@name = "config-guess"

  file("license_patch", "#{__DIR__}/../patches/config_guess/add-license-file.patch")

  def build : Nil
    patch(file("license_patch"), string: true)

    mkdir(target_path, parents: true)
    copy("config.guess", target_path)
    copy("config.sub", target_path)
  end

  def configure : Nil
    version("12.2.0")
    license("GPL-3.0 (with exception)")
    license_file("LICENSE")
    source("https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-#{version}.tar.gz")
  end

  def target_path
    File.join(smart_install_dir, "embedded", "lib", "config_guess")
  end
end
