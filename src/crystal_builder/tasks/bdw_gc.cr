@[Barista::BelongsTo(CrystalBuilder)]
class Tasks::BdwGC < Barista::Task
  include Common::Task

  @@name = "boehm-gc"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))

    command("git clone https://github.com/ivmai/libatomic_ops .")

    command("./autogen.sh", env: env)
    command("./configure --prefix=#{install_dir}/embedded", env: env)
    command("make -j", env: env)
  end

  def configure : Nil
    version("8.2.2")
    license("MIT-style")
    license_file("LICENSE")
    source("https://github.com/ivmai/bdwgc/releases/download/v8.2.2/gc-#{version}.tar.gz")
  end
end
