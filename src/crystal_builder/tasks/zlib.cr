@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::Zlib < Barista::Task
  include Common::Task

  @@name = "zlib"

  def build : Nil
    env = with_standard_compiler_flags(with_destdir)
    env["CFLAGS"] += " -O3"
    env["CFLAGS"] += " -fno-omit-frame-pointer"

    command("./configure --prefix=#{install_dir}/embedded", env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def configure : Nil
    version("1.2.13")
    license("Zlib")
    license_file("LICENSE")
    source("https://github.com/madler/zlib/archive/refs/tags/v#{version}.tar.gz")
  end
end
