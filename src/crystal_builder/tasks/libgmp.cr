@[Barista::BelongsTo(FullBuilder)]
class Tasks::LibGMP < Barista::Task
  include Common::Task

  @@name = "libgmp"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path)
    mkdir("#{smart_install_dir}/embedded", parents: true)
    command("./configure --prefix=#{smart_install_dir}/embedded", env: env)
    command("make", env: env)
    command("make check")
    command("make install", env: env)
  end

  def configure : Nil
    license("LGPLv3")
    license_file("COPYING.LESSERv3")
    version("6.2.1")
    preserve_symlinks(false)
    source("https://gmplib.org/download/gmp/gmp-#{version}.tar.lz")
  end
end
