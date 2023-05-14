@[Barista::BelongsTo(QuickBuilder)]
class Tasks::CrystalQuickCompiler < Barista::Task
  include Common::Task
  
  @@name = "crystal-quick"

  def build : Nil
    env = with_standard_compiler_flags(with_embedded_path(with_destdir))
    env["PREFIX"] = "#{install_dir}/embedded"

    mkdir("#{smart_install_dir}/bin", parents: true)

    command("make clean", env: env)
    command("make crystal #{flags}", env: env)
    command("make install", env: env)
    link("../embedded/bin/crystal", "bin/crystal", chdir: smart_install_dir)
  end

  def flags
    arr = ["stats=1", "interpreter=1"]

    arr.join(" ")
  end

  def configure : Nil
    version(finder.crystal_version)
    license("Apache-2.0")
    license_file("LICENSE")
    source("https://github.com/crystal-lang/crystal/archive/#{version}.tar.gz")
  end
end
