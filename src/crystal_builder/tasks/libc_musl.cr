@[Barista::BelongsTo(FullBuilder)]
class Tasks::LibCMusl < Barista::Task
  include Common::Task

  @@name = "libc-musl"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
    command("./configure --prefix=#{install_dir}/embedded --syslibdir=#{install_dir}/embedded/lib", env: env)
    command("make", env: env)
    command("make install", env: env)
  end

  def build_dir
    File.join(source_dir, "build")
  end

  def configure : Nil
    license("MIT")
    license_file("LICENSE")
    version("1.2.4")
    source("https://git.musl-libc.org/cgit/musl/snapshot/musl-#{version}.tar.gz")
  end
end
