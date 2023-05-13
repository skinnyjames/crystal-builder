@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::LibGMP < Barista::Task
  include Common::Task

  @@name = "libgmp"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
    command("./configure --prefix=#{install_dir}/embedded", env: env)
    command("make", env: env)
    command("make check")
    command("make install", env: env)
  end

  def configure : Nil
    license("LGPLv3")
    license_file("COPYING.LESSERv3")
    version("6.2.1")
    source("https://gmplib.org/download/gmp/gmp-#{version}.tar.lz")
  end
end
